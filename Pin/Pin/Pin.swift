//
//  Pin.swift
//  Pin
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

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

public extension UIView {
	
	public func pin(_ edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0.0, relative:Bool = false, debugMargin:Bool = false) {
		
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
		let anchorPoint = anchor ?? edge
		let parentview = superview!
		translatesAutoresizingMaskIntoConstraints = false
		
		let marginView = MarginView(forView: self)
		marginView.backgroundColor = debugMargin ? .red : .clear
		parentview.addSubview(marginView)
		
		// pin the width or height as needed..
		marginView.pin((edge.axis == .x) ? .height : .width, to: 1.0)

		// center in the parent view..
		marginView.pin(onAxis: edge.axis == .y ? .x : .y, inView: parentview)
		
		if relative {
			// setup the relative dimension
			marginView.pin((edge.axis == .x) ? .width : .height, to: margin, ofView:parentview)
		}
		else {
			// setup the fixed dimensionz
			marginView.pin((edge.axis == .x) ? .width : .height, to: margin)
		}

		// pin the margin to the view
		marginView.pin(edge, toView: view, toAnchor:anchorPoint)

		
		// when x or y center second anchor point, we can not fix
		// the margin view like this..
		let forceAnchor = anchorPoint == .centerX || anchorPoint == .centerY
		
		if forceAnchor {
			pin(edge, toView: marginView, toAnchor:edge.inverted, margin:margin)
		}
		else {
			
			// pin ourselves to the margin..
			pin(edge, toView: marginView, toAnchor:(anchor == nil) ? anchorPoint.inverted : anchor)
		}
	}
	
	public func pin(onAxis:PinAxis, inView view:UIView, withOffset offset:CGFloat = 0) {
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
		let constraint = NSLayoutConstraint(item: self, attribute: onAxis.attribute,
		                                    relatedBy: .equal,
		                                    toItem: view, attribute: onAxis.attribute,
		                                    multiplier: 1.0, constant: offset)
		view.addConstraint(constraint)
	}
	
	public func pin(_ dimension:PinDimension, to percent:CGFloat, ofView view:UIView, maintainAspect aspect:CGFloat? = nil) {
		let marginSizeConstraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                              relatedBy: .equal,
		                                              toItem: view, attribute: dimension.attribute,
		                                              multiplier: percent, constant: 0)
		view.addConstraint(marginSizeConstraint)
		
		if let aspect = aspect {
			let aspectconstraint = NSLayoutConstraint(item: self, attribute: dimension.inverted.attribute,
			                                          relatedBy: .equal,
			                                          toItem: self, attribute: dimension.attribute,
			                                          multiplier: dimension == .width ? 1/aspect : aspect, constant: 0)
			addConstraint(aspectconstraint)
		}
	}
	
	public func pin(_ dimension:PinDimension, to value:CGFloat, maintainAspect aspect:CGFloat? = nil) {
		let constraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                    relatedBy: .equal,
		                                    toItem: nil, attribute: .notAnAttribute,
		                                    multiplier: 1.0, constant: value)
		addConstraint(constraint)
		
		if let aspect = aspect {
			let aspectconstraint = NSLayoutConstraint(item: self, attribute: dimension.inverted.attribute,
			                                    relatedBy: .equal,
			                                    toItem: self, attribute: dimension.attribute,
			                                    multiplier: aspect, constant: 0)
			addConstraint(aspectconstraint)
		}
	}

	
	private func pin(_ edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0) {
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
		let anchor = anchor ?? edge
		let parentview = superview!
		let constraint = NSLayoutConstraint(item: self, attribute: edge.attribute,
		                                    relatedBy: .equal,
		                                    toItem: view, attribute: anchor.attribute,
		                                    multiplier: 1.0, constant: margin)
		parentview.addConstraint(constraint)
	}
}

