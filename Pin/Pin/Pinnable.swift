//
//  Pinnable.swift
//  Pinnable
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

/**
Pinnable protocol. Used to constrain elements together.
- author:
- version:
	0.1.4
*/
public protocol Pinnable {
	
	func pin(dimension:PinDimension, to value:CGFloat, relativeTo view:UIView?, aspectRatio aspect:CGFloat?) -> Pin
	func pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge?, margin:CGFloat, relative:Bool) -> Pin
	func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat) -> Pin
}

/**
what is a pin?

a Pin is a collection of layout constraints and associated properties
that define the positioning or size of a view, possibly in relation to
another view or itself. the pin object lets you control Pins the layout
after it has been setup.
*/

public class Pin {

	public let type:PinType
	public let axis:PinAxis
	public let isRelative:Bool

	public var value:CGFloat {
		return isRelative
			? constraint(forAttribute: type)?.multiplier ?? 0
			: constraint(forAttribute: type)?.constant ?? 0
	}
	public var layoutConstraints:[NSLayoutConstraint] {
		var constraints = children.flatMap({return $0.constraints})
		constraints.append(contentsOf: self.constraints)
		return constraints
	}
	public var isActive:Bool = true {
		didSet {
			
			layoutConstraints.forEach({
				$0.isActive = isActive
			})
		}
	}
	private var children:[Pin] = []
	private var constraints:[NSLayoutConstraint] = []
	
	public init(edge:PinEdge, pins:[Pin] = [], constraints:[NSLayoutConstraint] = [], isRelative:Bool = false) {
		self.type = .edge
		self.axis = edge.axis
		self.children = pins
		self.constraints = constraints
		self.isRelative = isRelative
	}
	
	public init(dimension:PinDimension, pins:[Pin] = [], constraints:[NSLayoutConstraint] = [], isRelative:Bool = false) {
		self.type = .dimension
		self.axis = dimension.axis
		self.children = pins
		self.constraints = constraints
		self.isRelative = isRelative
	}
	
	public init(axis:PinAxis, pins:[Pin] = [], constraints:[NSLayoutConstraint] = [], isRelative:Bool = false) {
		self.type = .axis
		self.axis = axis
		self.children = pins
		self.constraints = constraints
		self.isRelative = isRelative
	}
	
	public func set(value:CGFloat) {
		guard isRelative else {
			constraint(forAttribute: type)?.constant = value
			return
		}
		guard
			let oldConstraint = constraint(forAttribute: type),
			let pin = drop(constraint: oldConstraint)
			else { return }

		let newConstraint = oldConstraint.setMultiplier(multiplier: value)
		pin.add(constraint: newConstraint)
	}
	
	private func add(constraint:NSLayoutConstraint) {
		constraints.append(constraint)
	}
	
	@discardableResult
	private func drop(constraint:NSLayoutConstraint) -> Pin? {
		if let idx = constraints.index(of: constraint) {
			constraints.remove(at: idx)
			return self
		}
		for pin in children {
			if let idx = pin.constraints.index(of: constraint) {
				pin.constraints.remove(at: idx)
				return pin
			}
		}
		return nil
	}

	private func constraint(forAttribute:PinType) -> NSLayoutConstraint? {

		switch forAttribute {
		case .dimension:
			return layoutConstraints.filter({c in
				guard
					let first = c.firstItem as? UIView
					else {return false}
				
				let second = c.secondItem as? UIView
				if isRelative {
					return first != second && second != nil
				}
				
				return true
			}).first
		case .axis:
			return layoutConstraints.first
		case .edge:
			let c = layoutConstraints.count == 1
				? layoutConstraints.first
				: layoutConstraints.filter({$0.firstAttribute == ((axis == .x) ? .width : .height)}).first
			return c
		}
	}
}

public enum PinType {
	case axis
	case dimension
	case edge
}
public protocol PinAttribute {

	/**
	* the NSLayoutAttribute that this attribute corresponds with
	*/
	var attribute:NSLayoutAttribute {get}
	
	/**
	* the inverse or opposite attribute of this attribute
	*
	* i.e
	* 		leading <-> trailing
	* or
	* 		top <-> bottom
	* or
	* 		x <-> y
	* 		width <-> height
	*/
	var inverted:Self {get}

	/**
	* The 'axis' of this attribute.
	*/
	var axis:PinAxis {get}
}
public enum PinAxis : String, PinAttribute {
	case x = "x"
	case y = "y"
	case none = "none"

	public var attribute:NSLayoutAttribute {
		switch self {
		case .x:
			return .centerX
		case .y:
			return .centerY
		case .none:
			return .notAnAttribute
		}
	}
	
	public var inverted: PinAxis {
		switch self {
		case .x:
			return .y
		case .y:
			return .x
		case .none:
			return .none
		}
	}
	
	public var axis: PinAxis {
		return self
	}
}
public enum PinDimension : String, PinAttribute {
	case width = "width"
	case height = "height"
	case none = "none"
	
	public var attribute:NSLayoutAttribute {
		switch self {
		case .width:
			return .width
		case .height:
			return .height
		case .none:
			return .notAnAttribute
		}
	}
	
	public var inverted:PinDimension {
		switch self {
		case .width:
			return .height
		case .height:
			return .width
		case .none:
			return .none
		}
	}
	
	public var axis: PinAxis {
		switch self {
		case .width:
			return .x
		case .height:
			return .y
		case .none:
			return .none
		}
	}
}
public enum PinEdge : String, PinAttribute {
	case centerX = "centerX"
	case centerY = "centerY"
	case leading = "leading"
	case trailing = "trailing"
	case top = "top"
	case bottom = "bottom"
	
	public var inverted:PinEdge {
		switch self {
		case .bottom:
			return .top
		case .top:
			return .bottom
		case .leading:
			return .trailing
		case .trailing:
			return .leading
		case .centerX:
			return .centerX
		case .centerY:
			return .centerY
		}
	}

	public var attribute:NSLayoutAttribute {
		switch self {
		case .bottom:
			return .bottom
		case .top:
			return .top
		case .leading:
			return .leading
		case .trailing:
			return .trailing
		case .centerX:
			return .centerX
		case .centerY:
			return .centerY
		}
	}

	public var axis:PinAxis {
		switch self {
		case .bottom, .top:
			return .y
		case .leading, .trailing:
			return .x
		case .centerY:
			return .y
		case .centerX:
			return .x
		}
	}
}
