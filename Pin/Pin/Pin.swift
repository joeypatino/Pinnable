//
//  Pin.swift
//  Pin
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

public enum PinEdgeOrientation {
	case horizontal
	case vertical
}

public enum PinDirection {
	case leftToRight
	case rightToLeft
}

public enum PinDimension {
	case width
	case height
	
	public var attribute:NSLayoutAttribute {
		switch self {
		case .width:
			return .width
		case .height:
			return .height
		}
	}
}

public enum PinEdge {
	case leading
	case trailing
	case top
	case bottom
	
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
		}
	}
	
	public var oppositeAttribute:NSLayoutAttribute {
		switch self {
		case .bottom:
			return .top
		case .top:
			return .bottom
		case .leading:
			return .trailing
		case .trailing:
			return .leading
		}
	}
	
	public var orientation:PinEdgeOrientation {
		switch self {
		case .bottom, .top:
			return .vertical
		case .leading, .trailing:
			return .horizontal
		}
	}
}

public extension UIView {
	
	public func pin(edge origin:PinEdge, toView view:UIView,
	                toAnchor anchor:PinEdge? = nil,
	                margin:CGFloat = 0.0, isRelative:Bool = false) {
		
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")

		translatesAutoresizingMaskIntoConstraints = false
		
		let anchorPoint = anchor ?? origin
		let parentview = superview!
		let marginView = UIView()
		marginView.translatesAutoresizingMaskIntoConstraints = false
		marginView.backgroundColor = .red
		parentview.addSubview(marginView)
		
		// pin the width or height as needed..
		marginView.pin(dimension: (origin.orientation == .horizontal) ? .height : .width, to: 2)
		
		// center in the parent view..
		marginView.pin(centered: origin.orientation == .vertical ? .horizontal : .vertical, inView: parentview)
		
		if isRelative {
			// setup the relative dimension
			marginView.pin(dimension: (origin.orientation == .horizontal) ? .width : .height, to: margin, ofView:parentview)
		}
		else {
			// setup the fixed dimension
			marginView.pin(dimension: (origin.orientation == .horizontal) ? .width : .height, to: margin)
		}
		
		// pin the margin to the view
		marginView.pin(edge: origin, toView: view, toAnchor:anchorPoint, margin:0)
		
		// pin ourselves to the margin..
		pin(edge: origin, toView: marginView, toAnchor:(anchor == nil) ? anchorPoint.inverted : anchor, margin:0)
	}
	
	private func pin(edge origin:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat) {
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
		translatesAutoresizingMaskIntoConstraints = false
		
		let anchor = anchor ?? origin
		let parentview = superview!
		let constraint = NSLayoutConstraint(item: self, attribute: origin.attribute,
		                                    relatedBy: .equal,
		                                    toItem: view, attribute: anchor.attribute,
		                                    multiplier: 1.0, constant: margin)
		parentview.addConstraint(constraint)
	}
	
	public func pin(centered onAxis:PinEdgeOrientation, inView view:UIView, withOffset offset:CGFloat = 0) {
		assert(superview != nil, "view must have a superview")
		
		let constraint = NSLayoutConstraint(item: self, attribute: (onAxis == .vertical) ? .centerY : .centerX,
		                                    relatedBy: .equal,
		                                    toItem: view, attribute: (onAxis == .vertical) ? .centerY : .centerX,
		                                    multiplier: 1.0, constant: offset)
		view.addConstraint(constraint)
	}
	
	public func pin(dimension:PinDimension, to percent:CGFloat, ofView view:UIView) {
		
		let parentview = view
		
		// the relative percent constraint
		let marginSizeConstraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                              relatedBy: .equal,
		                                              toItem: parentview, attribute: dimension.attribute,
		                                              multiplier: percent, constant: 0)
		// the parent takes the constraint since it's the reference
		parentview.addConstraint(marginSizeConstraint)
	}
	
	public func pin(dimension:PinDimension, to value:CGFloat) {
		let constraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                    relatedBy: .equal,
		                                    toItem: nil, attribute: .notAnAttribute,
		                                    multiplier: 1.0, constant: value)
		addConstraint(constraint)
	}
}

