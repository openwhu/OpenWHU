# -*- coding: utf-8 -*-
"""
Created on Fri Jan 17 10:49:55 2020

@author: JinlongLi
"""

import networkx as nx
import matplotlib.pyplot as plt
import seaborn
from collections import defaultdict

# 网络流图F中存储边流量的键为 'flow'
# 原图G和剩余图R边容量值为 'capacity'
# todo: 两者似乎应该统一起来 都用'capacity'

# Ford-Fulkson方法
def initialize_residual_g(G, F):
    # R can be initialized as G
    '''# 根据原图G和流图F计算剩余图R
    
    Params:
        G: nx.DiGraph 有向图
        F: 有向图 
    Return:
        R: a directed graph as Residual Graph
    '''
    R = nx.DiGraph()
    R.add_nodes_from(G.nodes)
    R.add_edges_from(G.edges)
    
    for e in G.edges:
        # 顺向剩余图 = 容量 - 流量 
        # 逆向 = 流量
        R.edges[e]['capacity'] = G.edges[e]['capacity'] - F.edges[e]['flow']
        if e[::-1] not in R.edges:
            R.add_edge(*e[::-1])
#            print("edges:", e, R.edges[e[::-1]])
        
        if 'capacity' not in R.edges[e[::-1]]:
            R.edges[e[::-1]]['capacity'] = 0
        R.edges[e[::-1]]['capacity'] += F.edges[e]['flow']
    return R

def update_residual_g(R, path, bottle_v):
    for i in range(len(path) - 1):
        R.edges[path[i], path[i+1]]['capacity'] -= bottle_v
        R.edges[path[i+1], path[i]]['capacity'] += bottle_v
    


# 在剩余图R（有向图）中寻找一条增广路径
def AnAugmentedPath(G, _s, _t):
    '''Find an augmented path in G
    
    Params:
        _s:
        _t:
    Return:
        path: (nodes list) empty if there exists no such path.
    '''
    # 用深度优先搜索寻找一条 _s -> _t的路径

    visted = defaultdict(bool)
    path = []
    
    def dfs(n, p):
        # 已经访问过的路径存在p 中
        # n is the node to be visted.
        visted[n] = True
        p.append(n)
        
        if n == _t:
            return True
        for anode in G.neighbors(n):
            if (not visted[anode]) and G.edges[n, anode]['capacity'] > 0 :
                if dfs(anode, p): 
                    return True
        
        visted[n] = False
        p.pop()
        return False
    if dfs(_s, path):
        return path
    else:
        return []

def print_graph(_G):
    for e in _G.edges:
        data = _G.edges[e]['capacity'] if 'capacity' in _G.edges[e] else _G.edges[e]['flow']
        print(e, ":", data)

    
def bottle_neck_v(path, _G):
    #图_G 路径path的瓶颈容量
    return min([_G.edges[path[i], path[i+1]]['capacity'] 
               for i in range(len(path)-1)])
    
# Ford-Fulkerson
def max_flow_fordfulkerson(G):
    '''返回有向图的最大流
    
    todo: 处理本方法不会终止的情况'''
    FlowG = nx.DiGraph()
    FlowG.add_nodes_from(G.nodes)
    FlowG.add_edges_from(G.edges)
    for e in G.edges:
        FlowG.edges[e]['flow'] = 0
        if e[::-1] not in FlowG.edges:
            FlowG.add_edge(*e[::-1])
        FlowG.edges[e[::-1]]['flow'] = 0
    
    R = initialize_residual_g(G, FlowG)
    while True:
        aug_path = AnAugmentedPath(R, 's', 't')
        if len(aug_path) == 0:
            break
        bottleneck_v = bottle_neck_v(aug_path, R)
        
        for i in range(len(aug_path) - 1):
            FlowG.edges[aug_path[i], aug_path[i+1]]['flow'] += bottleneck_v
        
        update_residual_g(R, aug_path, bottleneck_v)
    return FlowG

# MCA 最大容量增值
def maximal_capacity(G):
    # 与福特妇科僧算法的区别在于增广路径的选择：从所有可能的增广路径中选择瓶颈容量最大的一个
    '''返回有向图的最大流
    
    todo: 处理本方法不会终止的情况'''
    FlowG = nx.DiGraph()
    FlowG.add_nodes_from(G.nodes)
    FlowG.add_edges_from(G.edges)
    for e in G.edges:
        FlowG.edges[e]['flow'] = 0
        if e[::-1] not in FlowG.edges:
            FlowG.add_edge(*e[::-1])
        FlowG.edges[e[::-1]]['flow'] = 0
    
    R = initialize_residual_g(G, FlowG)
    while True:
        aug_path = max_capacity_augumented_path(R, 's', 't')
        if len(aug_path) == 0:
            break
        bottleneck_v = bottle_neck_v(aug_path, R)
        
        for i in range(len(aug_path) - 1):
            FlowG.edges[aug_path[i], aug_path[i+1]]['flow'] += bottleneck_v
        
        update_residual_g(R, aug_path, bottleneck_v)
    return FlowG

def max_capacity_augumented_path(G, _s, _t):
    '''Find an augmented path, which has the max capacity in all augpath, in G
    
    Params:
        _s: source node 源点
        _t: target node(sink node 汇点)
    Return:
        path: nodes list representing max capacity augmented_path.
                empty if there exists no such path.
    '''
    # 使用迪杰斯特拉算法寻找最大容量增广路径
    path = {_s: None}
    # dijkstra algorithm
    # initialize D
    D = {} # 存储源点到其他所有点路径的最大容量 (D[_s] = ?)
    # D[n] is _s 到 n的路径的路径最大容量
    for n in G.nodes:
        if n is not _s:
            if (_s, n) in G.edges:
                D[n] = G.edges[_s, n]['capacity']
                path[n] = _s
            else:
                D[n] = 0
                path[n] = None
    Y, X = set(G.nodes), set()
    Y.remove(_s); X.add(_s) # X 是已经寻找到最大容量路径的节点集
    
    while len(Y) > 0:
        max_node = max(Y, key=lambda x: D[x])
        X.add(max_node); Y.remove(max_node)
        
        for n in G.neighbors(max_node):
            if n in Y and ((max_node, n) in G.edges) \
                and D[n] < min(D[max_node], G.edges[max_node, n]['capacity']):
                    
                D[n] = min(D[max_node], G.edges[max_node, n]['capacity'])
                path[n] = max_node
    # Extract The Maximal Capacity Path
    last_node = _t
    maximal_capacity_augpath = [_t]
    while path[last_node] is not None:
        maximal_capacity_augpath.append(path[last_node])
        last_node = path[last_node]
#    return D[_t], maximal_capacity_augpath[::-1]
    if len(maximal_capacity_augpath) == 1: # path only has node _t
        return []
    else:
        return maximal_capacity_augpath[::-1]

# MPLA 最短路径增值
        
def initialize_flow_g(G):
    FlowG = nx.DiGraph()
    FlowG.add_nodes_from(G.nodes)
    FlowG.add_edges_from(G.edges)
    for e in G.edges:
        FlowG.edges[e]['flow'] = 0
        if e[::-1] not in FlowG.edges:
            FlowG.add_edge(*e[::-1])
        FlowG.edges[e[::-1]]['flow'] = 0
    return FlowG
    

def calculate_level_g(G, _s):
    '''根据图G 计算源点为_s的层次图

    time complexity 时间复杂性怎么分析？
    '''
    L = nx.DiGraph()
    L.add_node(_s, level=0)
    
    # BFS 构建层次图  用一个队列辅助
    Q = [_s] # .pop(0) .append()
    visted = defaultdict(bool) # 防止重复访问边 (处理有环图)
    
    while len(Q) > 0:
        e = Q.pop(0)
        for n in G.neighbors(e):
            
            if (not visted[(e, n)]) and G.edges[e, n]['capacity'] > 0:
                visted[(e, n)] = True
                Q.append(n)
                if n in L.nodes:
                    if L.nodes[n]['level'] > L.nodes[e]['level'] + 1:
                        for pre_node in list(L.predecessors(n)):
                            L.remove_edge(pre_node, n)
                        L.add_edge(e, n, capacity=G.edges[e, n]['capacity'])
                        
                        L.nodes[n]['level'] = L.nodes[e]['level'] + 1
                    elif L.nodes[n]['level'] == L.nodes[e]['level'] + 1:
                        L.add_edge(e, n, capacity=G.edges[e, n]['capacity'])
                else:
                    L.add_node(n, level=L.nodes[e]['level'] + 1)
                    L.add_edge(e, n, capacity=G.edges[e, n]['capacity'])
    return L
    # each edge has are visted once only, O(m)

def update_level_g(G, path, bottleneck_capacity):
    # update level graph capacity along the path
    for i in range(len(path) - 1):
        G.edges[path[i], path[i+1]]['capacity'] -= bottleneck_capacity

def update_flow_g(G, path, bottleneck_flow):
    for i in range(len(path) - 1):
        G.edges[path[i], path[i+1]]['flow'] += bottleneck_flow
    
def MPLA(G, _s='s', _t='t'):
    # 算法16.2
    
    # initialize Flow Graph
    FlowG = initialize_flow_g(G)
    
    R = initialize_residual_g(G, FlowG)
    L = calculate_level_g(R, _s) # 计算层次图
    while _t in L.nodes:
        
        aug_path = max_capacity_augumented_path(L, _s, _t) # find a path in L graph

        while len(aug_path) > 0: # 存在_s -> _t路径
            bottleneck_v = bottle_neck_v(aug_path, R)
            
            for i in range(len(aug_path) - 1):
                FlowG.edges[aug_path[i], aug_path[i+1]]['flow'] += bottleneck_v
        
            update_residual_g(R, aug_path, bottleneck_v)
            # update level graph:`update_level_g(L, aug_path, bottleneck_v)`
            for i in range(len(aug_path) - 1):
                L.edges[aug_path[i], aug_path[i+1]]['capacity'] -= bottleneck_v
            aug_path = max_capacity_augumented_path(L, _s, _t)
            
        L = calculate_level_g(R, _s)
    return FlowG

## Dinic算法  

def dinic_maxflow(G, _s='s', _t='t'):
    FlowG = initialize_flow_g(G)
    
    R = initialize_residual_g(G, FlowG)
    
    # 层次图是无环简单有向图
    L = calculate_level_g(R, _s)
    
    # 批量增广路径
    while _t in L.nodes:
        u = _s
        p = [u]
        while L.out_degree(_s) > 0:
            while u != _t and L.out_degree(_s) > 0:
                if L.out_degree(u) > 0:
                    n = list(L.neighbors(u))[0]
                    p.append(n)
                    u = n
                else:
                    for pre_node in list(L.predecessors(u)):
                        L.remove_edge(pre_node, u)
                    L.remove_node(u)
                    p.pop()
                    u = p[-1]
            if u == _t: # p is an augment path
                bottleneck_v = bottle_neck_v(p, L)
                update_flow_g(FlowG, p, bottleneck_v)
                update_residual_g(R, p, bottleneck_v)
                update_level_g(L, p, bottleneck_v)
                    
                # 移除层次图中的饱和边
                for i in range(len(p) - 1):
                    if R.edges[p[i], p[i+1]]['capacity'] == 0:
                        L.remove_edge(p[i], p[i+1]) 
                # update u as the furthest reachable node starting from _s in p  in L            
                for i in range(len(p) - 1):
                    if R.edges[p[i], p[i+1]]['capacity'] == 0:
                        p = p[:i+1]
                        u = p[i]
                        break  

        L = calculate_level_g(R, _s)
    return FlowG

if __name__ == '__main__':
    # 算法书图16.3
    G = nx.DiGraph()
    G.add_edge('s', 'a', capacity=16)
    G.add_edge('s', 'b', capacity=13)
    G.add_edge('a', 'b', capacity=4)
    G.add_edge('b', 'a', capacity=10)
    G.add_edge('a', 'c', capacity=12)
    # G.add_edge('b', 'c', capacity=9)
    G.add_edge('b', 'd', capacity=14)
    G.add_edge('c', 'b', capacity=9)
    G.add_edge('d', 'c', capacity=7)
    G.add_edge('c', 't', capacity=20)
    G.add_edge('d', 't', capacity=4)
    nx.draw(G, with_labels=True)
    plt.show()

#    f = (max_flow_fordfulkerson(G))
#    print_graph(f)
    
    
#    print(max_capacity_augumented_path(G, 's', 't'))
#    f = maximal_capacity(G)
#    print_graph(f)
    f = dinic_maxflow(G, 's', 't')
    print_graph(f)