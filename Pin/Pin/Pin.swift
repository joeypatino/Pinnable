//
//  Pin.swift
//  Pin
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

/**
Pin protocol. Used to constrain elements together.

- author:
- version:
	0.1.2
- returns:
- throws:

While this currently is only configured for UIView constraints,
it could technically be extended for CAConstraints as well.
*/
public protocol Pin {
	func pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge?, margin:CGFloat, relative:Bool, debugMargin:Bool)
	func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat)
	func pin(_ dimension:PinDimension, to percent:CGFloat, ofView view:UIView, aspectRatio aspect:CGFloat?)
	func pin(_ dimension:PinDimension, to value:CGFloat, aspectRatio aspect:CGFloat?)
}


public protocol PinAttribute {
	associatedtype AttributeType
	var attribute:NSLayoutAttribute {get}
	var inverted:AttributeType {get}
	var axis:PinAxis {get}
}

/**
* A Pin for a views axis.
*/
public enum PinAxis : PinAttribute {
	public typealias AttributeType = PinAxis
	case x
	case y
	case none
	
	// the NSLayout attribute that relates to this PinAxis
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

/**
* A Pin for a views size.
*/
public enum PinDimension : PinAttribute {
	public typealias AttributeType = PinDimension
	case width
	case height
	case none
	
	// the NSLayout attribute that relates to this PinDimension
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
	
	/**
	* An inversion of this PinDimension.
	*/
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


/**
* A Pin for edges. Used when aligning UIViews to other
* sibling UIView's
*/
public enum PinEdge : PinAttribute {
	public typealias AttributeType = PinEdge
	case centerX
	case centerY
	case leading
	case trailing
	case top
	case bottom
	
	/** An inversion of this PinEdge.
	* 		leading <-> trailing
	* or
	* 		top <-> bottom
	*/
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
	
	// the NSLayout attribute that relates to this PinEdge
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
	
	/**
	* The 'axis' of this PinEdge. When the PinEdge is
	* leading or trailing, the axis is horizontal <---->
	* otherwise vertical
	*/
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
