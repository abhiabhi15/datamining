__author__ = 'abhishek'

import networkx as nx
import pandas as pd
import math
import statsmodels.formula.api as sm
import numpy as np
from scipy.spatial import distance
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import mean_squared_error
import aqi_index as aq
import matplotlib.pyplot as plt

#feature_list = ["temperature", "humidity", "wind_speed"]
feature_list = ["weather", "temperature", "pressure", "humidity", "wind_speed", "wind_direction"]
aqi_list = ["PM25_Concentration", "PM10_Concentration", "NO2_Concentration", "CO_Concentration", "O3_Concentration",
               "SO2_Concentration"]
info_list = ["id", "label", "time", "station_id", "latitude", "longitude", "aqi"]

v_list, u_list = [], []  # Storing Nodes (Labeled = v_list, Unlabeled = u_list)
edge_feature_DF, feature_params = None, None
MIN_DIST = 0.35
LABEL_KNOWN = "known"
LABEL_UNKNOWN = "unknown"
AQI_POLLUTANTS = "aqi_pollutants"
FEATURES = "features"

def get_labeled_node_edges():
    edges = []
    for vnode in v_list:
        for unode in u_list:
            t = vnode, unode, 1
            edges.append(t)
    return edges

def compute_distance(t1, t2):
    return math.sqrt(math.pow(t1[0] - t2[0], 2) + math.pow(t1[1] - t2[1], 2))

def get_neighbor_node_edges(G):
    edges = []
    for k1, v1 in G.nodes_iter(data=True):
        for k2, v2 in G.nodes_iter(data=True):
            if k1 != k2:
                dist = compute_distance([v1["latitude"], v1["longitude"]],
                                       [v2["latitude"], v2["longitude"]])
                if dist <= MIN_DIST and not(G.has_edge(k1, k2)):
                    t = k1, k2, 1
                    edges.append(t)
    return edges

def add_graph_edges(G):
    G.add_weighted_edges_from(get_labeled_node_edges()) # Adding edges from Labeled to unlabeled nodes
    G.add_weighted_edges_from(get_neighbor_node_edges(G)) #Adding Neighbourhood Edges

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

def create_graph(df):

    G = nx.Graph()
    row_iterator = df.iterrows()
    for i, row in row_iterator:
        props = extract_properties(row)
        if props['label'] == LABEL_KNOWN:
            v_list.append(props['id'])
        elif props['label'] == LABEL_UNKNOWN:
            u_list.append(props['id'])
        G.add_node(row['id'], props)
    add_graph_edges(G)
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
        # plt.scatter(fDF["feature_diff"], fDF["aqi_sim"])
        # plt.show()
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
    for pollutant in aq.pollutants:
        df[pollutant] =  df[pollutant].apply(lambda x: aq.get_aqi_value(x, pollutant))

    df[["aqi"]] = df[["aqi"]].apply(lambda x: MinMaxScaler().fit_transform(x))
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
    print "Actual List = ", actual_list
    print "Predicted List = ", predicted_list
    rms = math.sqrt(mean_squared_error(actual_list, predicted_list))
    print "RMSE = " , rms


def aqi_inference(df):
    aq.init_aqi_index()
    df = preprocess_DF(df)
    G = create_graph(df)
    init_edge_weights(G)
    predicted_list = calc_aqi_distribution(G)
    compute_rmse(predicted_list, G)
    print "Number of edges = ",  G.number_of_edges()
    print "Number of nodes = ",  G.number_of_nodes()
    G.clear()


if __name__ == '__main__':
    df = pd.read_csv('/home/abhishek/PycharmProjects/programs/data/winter_beijing_T274.csv', sep=',')
    aqi_inference(df)