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


/**
* A Pin for a views axis.
*/
public enum PinAxis {
	case x
	case y
	
	// the NSLayout attribute that relates to this PinAxis
	public var attribute:NSLayoutAttribute {
		switch self {
		case .x:
			return .centerX
		case .y:
			return .centerY
		}
	}
}

/**
* A Pin for a views size.
*/
public enum PinDimension {
	case width
	case height
	
	// the NSLayout attribute that relates to this PinDimension
	public var attribute:NSLayoutAttribute {
		switch self {
		case .width:
			return .width
		case .height:
			return .height
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
		}
	}
}


/**
* A Pin for edges. Used when aligning UIViews to other
* sibling UIView's
*/
public enum PinEdge {
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
