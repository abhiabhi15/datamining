__author__ = 'abhishek'

import networkx as nx
import pandas as pd
import math
import statsmodels.formula.api as sm
import numpy as np
from sklearn.preprocessing import MinMaxScaler, Imputer
from numpy.linalg import inv

feature_list = ["PM25_Concentration", "PM10_Concentration", "NO2_Concentration", "CO_Concentration", "O3_Concentration",
               "SO2_Concentration", "weather", "temperature", "pressure", "humidity", "wind_speed", "wind_direction"]
info_list = ["id", "label", "time", "station_id", "latitude", "longitude", "aqi"]

v_list, u_list = [], []  # Storing Nodes (Labeled = v_list, Unlabeled = u_list)
weight_list, edge_feature_DF, feature_params = None, None, None
MIN_DIST = 0.20
LABEL_KNOWN = "known"
LABEL_UNKNOWN = "unknown"

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
    # Adding edges from Labeled to unlabeled nodes
    G.add_weighted_edges_from(get_labeled_node_edges())

    #Adding Neighbourhood Edges
    G.add_weighted_edges_from(get_neighbor_node_edges(G))

    #TODO: Add Next Time Layer Nodes Edges

def extract_properties(r):
    dict = r.to_dict()
    props, fdict = {}, {}
    for key, value in dict.iteritems():
        if key in feature_list:
            fdict[key] = value
        elif key in info_list:
            props[key] = value
    props["features"] = fdict
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
    ids, fname, fdiff, aqidiff ,labels = [], [], [], [], []
    for k,v in G.edges_iter():
        for feature in feature_list:
            ids.append(k + "_" + v)
            fname.append(feature)
            fdiff.append(G.node[k]["features"][feature] - G.node[v]["features"][feature])
            aqidiff.append(G.node[k]["aqi"] - G.node[v]["aqi"])
            if G.node[k]["label"] == LABEL_KNOWN and G.node[k]["label"] == LABEL_KNOWN:
                labels.append(LABEL_KNOWN)
            else:
                labels.append(LABEL_UNKNOWN)

    d = {"id": ids, "fname": fname, "feature_diff": fdiff, "aqi_diff": aqidiff, "label": labels}
    return pd.DataFrame(d, columns=["id", "fname", "feature_diff", "aqi_diff", "label"])

def learn_feature_params(feature_DF):
    feature_params = {}
    for feature in feature_list:
        fDF = feature_DF.loc[(feature_DF['fname'] == feature) & (feature_DF['label'] == LABEL_KNOWN)].dropna()
        if fDF.empty:
            result.params = [0, 0]
        else:
            result = sm.ols(formula="aqi_diff ~ feature_diff", data=fDF).fit()
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
                summation += math.pow(weight_list[feature], 2) * AFk
        G.edge[k][v]['weight'] = math.exp(-summation)


def init_feature_weights():
    global weight_list
    weight_list = {}
    for feature in feature_list:
        weight_list[feature] = 1


def preprocess_DF(df):
    df.replace('NULL', np.nan)
    df = df.fillna(df.mean())
    df[feature_list] = df[feature_list].apply(lambda x: MinMaxScaler().fit_transform(x))
    df[["aqi"]] = df[["aqi"]].apply(lambda x: MinMaxScaler().fit_transform(x))
    return df


def get_unlabeled_nodes_aqi_distribution(G):
    diag_list = []
    weight_matrix_u = None
    weight_matrix_uv = None

    for unode in u_list:

        # Calculating D(u,u)
        w_sum = 0
        for tuple in G.edges(unode, data='weight'):
            if tuple[1] in u_list:
                w_sum += tuple[2]
        diag_list.append(w_sum)

        # Calculating W(u,u)
        w_list = []
        for other_unode in u_list:
            if G.has_edge(unode, other_unode):
                w_list.append(G[unode][other_unode]['weight'])
            else:
                w_list.append(0)

        w_arr = np.array(w_list).reshape(1, len(u_list))
        if weight_matrix_u is None:
            weight_matrix_u = w_arr
        else:
            weight_matrix_u = np.concatenate((weight_matrix_u, w_arr), axis=0)

        # Calculating W(u,v)
        w_list = []
        for vnode in v_list:
            if G.has_edge(unode, vnode):
                w_list.append(G[unode][vnode]['weight'])
            else:
                w_list.append(0)

        w_arr = np.array(w_list).reshape(1, len(v_list))
        if weight_matrix_uv is None:
            weight_matrix_uv = w_arr
        else:
            weight_matrix_uv = np.concatenate((weight_matrix_uv, w_arr), axis=0)

    diag_matrix = np.diag(np.array(diag_list))

    # Calculating Pv
    pv_list = []
    for vnode in v_list:
        pv_list.append(G.node[vnode]['aqi'])
    pv_matrix = np.array(pv_list).reshape((len(v_list), 1))

    print "Diagonal Matrix\n", diag_matrix, "\n ======================= \n"
    print "Weight Matrix U\n", weight_matrix_u, "\n ======================= \n"
    ## Compute Pu
    print "Subtract Matrix U\n", np.subtract(diag_matrix, weight_matrix_u), " \n =============== \n"
    uinv = inv(np.subtract(diag_matrix, weight_matrix_u))
    print "Inverse Matrix U\n", uinv, " \n======================= \n"
    pp = np.dot(uinv, weight_matrix_uv)
    print "PP Matrix \n", pp, " \n======================= \n"
    pu = np.dot(pp, pv_matrix)
    print(pu)


def calculate_entropy(p_u):
    pass


def aqi_inference(df):
    df = preprocess_DF(df)
    G = create_graph(df)
    init_feature_weights()
    init_edge_weights(G)
    p_u = get_unlabeled_nodes_aqi_distribution(G)
    h_p_u = calculate_entropy(p_u)

    G.clear()


if __name__ == '__main__':
    df = pd.read_csv('/home/abhishek/PycharmProjects/programs/data/winter_beijing_T274.csv', sep=',')
    aqi_inference(df)