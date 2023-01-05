//
//  Node.swift
//  GraphLayout
//
//  Created by kun wang on 2023/1/4.
//

import Foundation

public enum Shape: String {
    case rectangle, box, hexagon, polygon, diamond, star, ellipse, circle, point
}

public enum NodeStyle {
    case rounded(CGFloat)
}

public class Node: Equatable {
    var gvlNode: GVLNode?

    public let label: String
    public var color: UIColor = UIColor.white
    public var highlihtedColor: UIColor = UIColor.lightGray
    public var borderColor: UIColor = UIColor.black
    public var borderWidth: Float = 1.0
    public var textColor: UIColor = UIColor.black
    public var fontSize: Int = 14
    public var shape: Shape = .ellipse
    public var style: NodeStyle = .rounded(4)

    public init(label: String) {
        self.label = label
    }

    public func getAttribute(name: String) -> String? {
        return gvlNode?.getAttributeForKey(name)
    }

    func setAttribute(name: String, value: String) {
        gvlNode?.setAttribute(value, forKey: name)
    }

    public func frame() -> CGRect? {
        return gvlNode?.frame()
    }

    public func bounds() -> CGRect? {
        return gvlNode?.bounds()
    }

    public func path() -> UIBezierPath? {
        return gvlNode?.path()
    }

    func prepare() {
        switch self.style {
        case .rounded(let corner):
            gvlNode?.nodeStyle = "rounded"
            gvlNode?.nodeRoundedCorner = corner
        }
        setAttribute(name: "fontsize", value: fontSize.description)
        setAttribute(name: "shape", value: shape.rawValue)
    }

    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs === rhs
    }
}
