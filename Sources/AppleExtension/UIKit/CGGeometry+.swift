//
//  CGGeometry+.swift
//  AppleExtension
//
//  Created by iran.qiu on 2023/6/19.
//

import CoreGraphics
#if canImport(UIKit)
import UIKit
#endif

/// 用于居中运算
public func __CGFloatGetCenter(_ parent: CGFloat, _ child: CGFloat) -> CGFloat {
    return (parent - child) * 0.5
}

// MARK: - CGFloat 拓展

public extension CGFloat {
    /// objective-c 中的 CGFLOAT_MAX
    static var maxValue: CGFloat {
        CGFloat.greatestFiniteMagnitude
    }

    /// objective-c 中的 CGFLOAT_MIN
    static var minValue: CGFloat {
        CGFloat.leastNormalMagnitude
    }

/// 1个像素点
#if canImport(UIKit)
    static var pixelOne: CGFloat {
        return 1 / UIScreen.main.scale
    }
#endif

    /// 某些地方可能会将 CGFloat.minValue 作为一个数值参与计算（但其实 CGFloat.minValue 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFloat.minValue 转换为 0
    func removeFloatMin() -> CGFloat {
        return self == CGFloat.minValue ? 0 : self
    }

    /// 基于指定的倍数，对 CGFloat 像素取整
    /// - Parameter scale: 指定的倍数，为 nil 则表示以当前设备的屏幕倍数为准
    /// - Returns: 取整后的值
    func flat(_ scale: CGFloat? = nil) -> CGFloat {
        var floatValue = self.removeFloatMin()
#if canImport(UIKit)
        let aScale = CGFloat.maximum(scale ?? UIScreen.main.scale, 1)
        floatValue = ceil(floatValue * aScale) / aScale
#endif
        return floatValue
    }
}

// MARK: - CGPoint 拓展

public extension CGPoint {
    /// 计算与另一个点的距离
    /// - Parameter point: 另一个点
    /// - Returns: 两点间距
    func distance(from point: CGPoint) -> CGFloat {
        return CGPoint.distance(between: self, to: point)
    }

    /// 计算两个点的距离
    /// - Parameters:
    ///   - point1: 第1个点
    ///   - point2: 第2个点
    /// - Returns: 两点间距
    static func distance(between point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2))
    }

    /// Add two CGPoints.
    /// - Parameters:
    ///   - lhs: CGPoint to add to.
    ///   - rhs: CGPoint to add.
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    /// Add a CGPoints to self.
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGPoint to add.
    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    /// Subtract two CGPoints.
    /// - Parameters:
    ///   - lhs: CGPoint to subtract from.
    ///   - rhs: CGPoint to subtract.
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    /// Subtract a CGPoints from self.
    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGPoint to subtract.
    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x -= rhs.x
        lhs.y -= rhs.y
    }

    /// Multiply a CGPoint with a scalar.
    /// - Parameters:
    ///   - point: CGPoint to multiply.
    ///   - scalar: scalar value.
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// Multiply self with a scalar.
    /// - Parameters:
    ///   - point: `self`.
    ///   - scalar: scalar value.
    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point.x *= scalar
        point.y *= scalar
    }

    /// Multiply a CGPoint with a scalar.
    /// - Parameters:
    ///   - scalar: scalar value.
    ///   - point: CGPoint to multiply.
    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    /// 将一个 CGPoint 像素对齐
    /// - Returns: 取整后的 CGPoint
    func flat() -> CGPoint {
        return CGPoint(x: x.flat(), y: y.flat())
    }
}

// MARK: - CGSize 拓展

public extension CGSize {
    /// 判断一个 CGsize 是否为空
    var isEmpty: Bool {
        return self.width == 0 || self.height == 0
    }

    /// 判断一个 CGSize 是否存在 null
    var isNaN: Bool {
        return width.isNaN || height.isNaN
    }

    /// 判断一个 CGSize 是否包含无穷大
    var isInInf: Bool {
        return width.isInfinite || height.isInfinite
    }

    /// 判断一个 CGSize 是否合法
    var isValidated: Bool {
        return !self.isEmpty && !self.isNaN && !self.isInInf
    }

    /// CGSizeMax
    static var maxSize: CGSize {
        CGSize(width: CGFloat.maxValue, height: CGFloat.maxValue)
    }

    /// - Parameters:
    ///   - lhs: CGSize to add to.
    ///   - rhs: CGSize to add.
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    /// - Parameters:
    ///   - lhs: CGSize to add to.
    ///   - tuple: tuple value.
    static func + (lhs: CGSize, tuple: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + tuple.width, height: lhs.height + tuple.height)
    }

    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGSize to add.
    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }

    /// - Parameters:
    ///   - lhs: `self`.
    ///   - tuple: tuple value.
    static func += (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width += tuple.width
        lhs.height += tuple.height
    }

    /// - Parameters:
    ///   - lhs: CGSize to subtract from.
    ///   - rhs: CGSize to subtract.
    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    /// - Parameters:
    ///   - lhs: CGSize to subtract from.
    ///   - tuple: tuple value.
    static func - (lhs: CGSize, tuple: (width: CGFloat, heoght: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width - tuple.width, height: lhs.height - tuple.heoght)
    }

    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGSize to subtract.
    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width -= rhs.width
        lhs.height -= rhs.height
    }

    /// - Parameters:
    ///   - lhs: `self`.
    ///   - tuple: tuple value.
    static func -= (lhs: inout CGSize, tuple: (width: CGFloat, height: CGFloat)) {
        lhs.width -= tuple.width
        lhs.height -= tuple.height
    }

    /// - Parameters:
    ///   - lhs: CGSize to multiply.
    ///   - rhs: CGSize to multiply with.
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// - Parameters:
    ///   - lhs: CGSize to multiply.
    ///   - scalar: scalar value.
    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    /// - Parameters:
    ///   - scalar: scalar value.
    ///   - rhs: CGSize to multiply.
    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        return CGSize(width: scalar * rhs.width, height: scalar * rhs.height)
    }

    /// - Parameters:
    ///   - lhs: `self`.
    ///   - rhs: CGSize to multiply.
    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs.width *= rhs.width
        lhs.height *= rhs.height
    }

    /// - Parameters:
    ///   - lhs: `self`.
    ///   - scalar: scalar value.
    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs.width *= scalar
        lhs.height *= scalar
    }

    /// 将一个 CGSize 像素对齐
    /// - Returns: 取整后的 CGSize
    func flat() -> CGSize {
        return CGSize(width: width.flat(), height: height.flat())
    }
}

// MARK: - CGRect 拓展

public extension CGRect {
    /// 获取 CGRect 的中心点
    var center: CGPoint { CGPoint(x: midX, y: midY) }

    /// 根据 center 和 size 生成 CGRect
    /// - Parameters:
    ///   - center: 中心点
    ///   - size: 尺寸
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        self.init(origin: origin, size: size)
    }

    /// 传入size，返回一个 x/y 为 0 的 CGRect
    /// - Parameter size: 尺寸
    init(size: CGSize) {
        self.init(origin: CGPoint.zero, size: size)
    }

#if canImport(UIKit)

    /// 为给定的 rect 往内部缩小 insets 的大小
    func insetsEdges(_ insets: UIEdgeInsets) -> CGRect {
        return CGRect(
            x: origin.x + insets.left,
            y: origin.y + insets.top,
            width: size.width - insets.horizontalValue,
            height: size.height - insets.verticalValue
        )
    }

#endif

    /// 设置一个 CGRect 的 x, y, width, height, size
    @discardableResult
    func set(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil, size: CGSize? = nil) -> CGRect {
        var rect = self

        if let x = x {
            rect.origin.x = x
        }
        if let y = y {
            rect.origin.y = y
        }
        if let width = width {
            rect.size.width = width
        }
        if let height = height {
            rect.size.height = height
        }
        if let size = size {
            rect.size = size
        }

        return rect
    }

    /// 将一个 CGRect 像素对齐
    /// - Returns: 取整后的 CGRect
    func flat() -> CGRect {
        return CGRect(x: origin.x.flat(), y: origin.y.flat(), width: size.width.flat(), height: size.height.flat())
    }
}

#if canImport(UIKit)

// MARK: - UIEdgeInsets 拓展

public extension UIEdgeInsets {
    /// 获取 UIEdgeInsets 在水平方向上的值
    var horizontalValue: CGFloat {
        return self.left + self.right
    }

    /// 获取 UIEdgeInsets 在垂直方向上的值
    var verticalValue: CGFloat {
        return self.top + self.bottom
    }

    /// 将两个 UIEdgeInsets 合并为一个
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: lhs.top + rhs.top, left: lhs.left + rhs.left, bottom: lhs.bottom + rhs.bottom, right: lhs.right + rhs.right)
    }
}

#endif
