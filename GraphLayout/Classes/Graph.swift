//
//  Graph.swift
//  GraphLayout
//
//  Copyright © 2018 bakhtiyor.com.
//  MIT License
//



public class Edge: Equatable {
    fileprivate var gvlEdge: GVLEdge?

    var from: Node
    var to: Node
    public var color: UIColor = UIColor.black
    public var width: Float = 1.0
    public var weight: Float = 1


    public init(from node1: Node, to node2: Node) {
        from = node1
        to = node2
    }

    public func getAttribute(name: String) -> String? {
        return gvlEdge?.getAttributeForKey(name)
    }

    func setAttribute(name: String, value: String) {
        gvlEdge?.setAttribute(value, forKey: name)
    }

    public func frame() -> CGRect? {
        return gvlEdge?.frame()
    }

    public func bounds() -> CGRect? {
        return gvlEdge?.bounds()
    }

    public func body() -> UIBezierPath? {
        return gvlEdge?.body()
    }

    public func headArrow() -> UIBezierPath? {
        return gvlEdge?.headArrow()
    }

    public func tailArrow() -> UIBezierPath? {
        return gvlEdge?.tailArrow()
    }

    func prepare() {
        setAttribute(name: "weight", value: weight.description)

    }

    public static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs === rhs
    }
}

public class SubGraph {
}

public enum Splines: String {
    case spline
    case polyline
    case ortho
    case curved
}

public class Graph {
    fileprivate var gvlGraph: GVLGraph?

    public private(set) var nodes = [Node]()
    public private(set) var edges = [Edge]()
    public private(set) var size = CGSize.zero
    public var splines: Splines = .spline
    
    public init() {
        gvlGraph = GVLGraph()
    }

    public func addNode(_ label: String) -> Node {
        let node = Node(label: label)
        nodes.append(node)
        return node
    }

    public func removeNode(node: Node) {
        guard nodes.count > 1 else { return }
        if let index = nodes.firstIndex(of: node) {
            for edge in edges {
                if edge.from == node || edge.to == node {
                    removeEdge(edge: edge)
                }
            }
            nodes.remove(at: index)
        }
    }

    public func addEdge(from node1: Node, to node2: Node) -> Edge {
        let edge = Edge(from: node1, to: node2)
        edges.append(edge)
        return edge
    }

    public func removeEdge(edge: Edge) {
        if let index = edges.firstIndex(of: edge) {
            edges.remove(at: index)
        }
    }

    public func applyLayout() {
        gvlGraph = GVLGraph()
        if let gvlGraph = self.gvlGraph {
            for node in nodes {
                let gvlNode = gvlGraph.addNode(node.label)
                node.gvlNode = gvlNode
                node.prepare()
            }
            for edge in edges {
                let gvlEdge = gvlGraph.addEdge(withSource: edge.from.gvlNode, andTarget: edge.to.gvlNode)
                edge.gvlEdge = gvlEdge
                edge.prepare()
            }

            prepare()
            gvlGraph.applyLayout()
            size = gvlGraph.size()
        }
    }

    func prepare() {
        gvlGraph?.setAttribute(splines.rawValue, forKey: "splines")
    }
}
