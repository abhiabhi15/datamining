import networkx as nx
import pandas as pd
import math
import statsmodels.formula.api as sm
import numpy as np
from scipy.spatial import distance
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error
import config as cfg

feature_list = ["weather", "temperature", "pressure", "humidity", "wind_speed", "wind_direction"]
aqi_list = ["PM25_Concentration", "PM10_Concentration", "NO2_Concentration", "CO_Concentration", "O3_Concentration",
               "SO2_Concentration"]
info_list = ["id", "label", "time", "station_id", "latitude", "longitude"]
v_list, u_list = [], []  # Storing Nodes (Labeled = v_list, Unlabeled = u_list)
edge_feature_DF, feature_params = None, None
LABEL_KNOWN = "known"
LABEL_UNKNOWN = "unknown"
AQI_POLLUTANTS = "aqi_pollutants"
FEATURES = "features"

def is_same_layer(node1, node2):
    return node1.split("_")[1] == node2.split("_")[1]

def is_same_station(node1, node2):
    return node1.split("_")[0] == node2.split("_")[0]

def connect_labeled_node_edges(G):
    edges = []
    for vnode in v_list:
        for unode in u_list:
            if is_same_layer(unode, vnode):
                t = vnode, unode, 1
                edges.append(t)
    if len(edges) > 0:
        G.add_weighted_edges_from(edges)

def compute_distance(t1, t2):
    return math.sqrt(math.pow(t1[0] - t2[0], 2) + math.pow(t1[1] - t2[1], 2))

def connect_neighbor_node_edges(G):
    edges = []
    for k1, v1 in G.nodes_iter(data=True):
        for k2, v2 in G.nodes_iter(data=True):
            if k1 != k2 and is_same_layer(k1, k2):
                dist = compute_distance([v1["latitude"], v1["longitude"]],
                                       [v2["latitude"], v2["longitude"]])
                if dist <= cfg.MIN_DIST and not(G.has_edge(k1, k2)):
                    t = k1, k2, 1
                    edges.append(t)
    if len(edges) > 0:
        G.add_weighted_edges_from(edges)

def connect_time_layer_node_edges(G):
    edges = []
    for unode in u_list:
        for other_unode in u_list:
            if is_same_station(unode, other_unode):
                 t = unode, other_unode, 1
                 edges.append(t)

    for vnode in u_list:
        for other_vnode in u_list:
            if is_same_station(vnode, other_vnode):
                 t = vnode, other_vnode, 1
                 edges.append(t)
    if len(edges) > 0:
        G.add_weighted_edges_from(edges)


def add_graph_edges(G):
    connect_labeled_node_edges(G) # Adding edges from Labeled to unlabeled nodes
    connect_neighbor_node_edges(G) # Adding Neighbourhood Edges
    connect_time_layer_node_edges(G) # Adding Different Time Layer Edges

def extract_properties(r):
    dict = r.to_dict()
    props, fdict, aqi_dict = {}, {}, {}
    for key, value in dict.iteritems():
        if key in feature_list:
            fdict[key] = value
        elif key in info_list:
            props[key] = value
        elif key in aqi_list:
            aqi_dict[key] = value

    props[AQI_POLLUTANTS] = aqi_dict
    props[FEATURES] = fdict
    return props

def add_graph_nodes(G, df):

    row_iterator = df.iterrows()
    for i, row in row_iterator:
        props = extract_properties(row)
        if props['label'] == LABEL_KNOWN:
            v_list.append(props['id'])
        elif props['label'] == LABEL_UNKNOWN:
            u_list.append(props['id'])
        G.add_node(row['id'], props)
    return G

def create_edge_feature_DF(G):
    ids, fname, fdiff, aqi_sim ,labels = [], [], [], [], []
    for k,v in G.edges_iter():
        for feature in feature_list:
            ids.append(k + "_" + v)
            fname.append(feature)
            fdiff.append(abs(G.node[k][FEATURES][feature] - G.node[v][FEATURES][feature]))
            dist = distance.euclidean(G.node[k][AQI_POLLUTANTS].values(), G.node[v][AQI_POLLUTANTS].values())
            aqi_sim.append(1/dist)
            if G.node[k]["label"] == LABEL_KNOWN and G.node[k]["label"] == LABEL_KNOWN:
                labels.append(LABEL_KNOWN)
            else:
                labels.append(LABEL_UNKNOWN)

    d = {"id": ids, "fname": fname, "feature_diff": fdiff, "aqi_sim": aqi_sim, "label": labels}
    return pd.DataFrame(d, columns=["id", "fname", "feature_diff", "aqi_sim", "label"])

def learn_feature_params(feature_DF):

    feature_params = {}
    for feature in feature_list:
        fDF = feature_DF.loc[(feature_DF['fname'] == feature) & (feature_DF['label'] == LABEL_KNOWN)].dropna()
        if fDF.empty:
            result.params = [0, 0]
        else:
            result = sm.ols(formula="aqi_sim ~ feature_diff", data=fDF).fit()
        feature_params[feature] = {"a": result.params[1], "b": result.params[0]}
    return feature_params


def init_edge_weights(G):
    global edge_feature_DF
    global feature_params

    edge_feature_DF = create_edge_feature_DF(G)
    feature_params = learn_feature_params(edge_feature_DF)

    ## Iterate all edges to update edge weights
    for k, v in G.edges_iter():
        node_features = edge_feature_DF.loc[edge_feature_DF["id"] == (k + "_" + v)]
        summation = 0
        for feature in feature_list:
            fdiff = node_features.loc[node_features["fname"] == feature]["feature_diff"].iat[0, 0]
            if not(math.isnan(fdiff)):
                AFk = ((feature_params[feature]["a"] * fdiff) + feature_params[feature]["b"]) * fdiff
                summation += AFk
        G.edge[k][v]['weight'] = math.exp(-summation)


def preprocess_DF(df):
   df.replace('NULL', np.nan)
   df = df.fillna(df.mean())
   df[feature_list] = df[feature_list].apply(lambda x: MinMaxScaler().fit_transform(x))
   return df

def calc_aqi_distribution(G):
    pu_list = []
    for unode in u_list:
        p_arr = None
        for vnode in v_list:
            if G.has_edge(unode, vnode):
                pv_list = []
                wt = G[unode][vnode]['weight']
                for k,v in G.node[vnode][AQI_POLLUTANTS].iteritems():
                    pv_list.append(wt * v)
                p_temp = np.array(pv_list).reshape(1, len(aqi_list))

                if p_arr is None:
                    p_arr = p_temp
                else:
                    p_arr = p_arr + p_temp

        p_arr = p_arr/G.degree(unode)
        pu_list.append(p_arr.tolist())

    flattened = [val for sublist in pu_list for val in sublist]
    return [val for sublist in flattened for val in sublist]


def compute_rmse(predicted_list, G):
    actual_vals = []
    for unode in u_list:
        actual_vals.append(G.node[unode][AQI_POLLUTANTS].values())
    actual_list = [val for sublist in actual_vals for val in sublist]
    return math.sqrt(mean_squared_error(actual_list, predicted_list))


def write_predicted_results(predicted_list):
    arr = np.array(predicted_list).reshape(len(u_list), len(aqi_list))
    predicted_df = pd.DataFrame(arr, columns=aqi_list)
    predicted_df.insert(0, "station_id", u_list)
    predicted_df.to_csv(cfg.OUTPUT_FILE, index=False)


def aqi_inference():
    G = nx.Graph() # Instantiating Graph Object
    for day in range(cfg.START_DAY, cfg.END_DAY, 1):
        file_name = cfg.FILEPATH + "winter_beijing_T" + `day` + ".csv"
        df = pd.read_csv(file_name, sep=',')
        df = preprocess_DF(df)
        G = add_graph_nodes(G, df)
    add_graph_edges(G)
    init_edge_weights(G)
    predicted_list = calc_aqi_distribution(G)
    rmse = compute_rmse(predicted_list, G)
    write_predicted_results(predicted_list)

    print "MIN_DIST = ", cfg.MIN_DIST
    print "RMSE = ", rmse
    print "Number of edges = ",  G.number_of_edges()
    print "Total Number of nodes = ",  G.number_of_nodes()
    print "Total Number of unknown nodes = ",  len(u_list)
    G.clear()

if __name__ == '__main__':
    aqi_inference()