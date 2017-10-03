//
//  UIView+Pin.swift
//  Pin
//
//  Created by Joey Patino on 10/3/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

extension UIView : Pin {}
public extension Pin where Self : UIView {
	
	/**
	Add Pin to constrain the edge of a UIView to the edge of another
	view.
	
	- Author:
	- returns:
	- throws:
	
	- parameters:
		- edge: the edge of this view to pin.
		- view: the view to pin this view to.
		- anchor: the edge of 'view' to pin this view to. defaults to 'edge'
		- margin: the margin between the views.  defaults to 0
		- relative: is the margin relative to the superviews bounds. defaults to false
	
	- Important:
	Self must already have a superview before calling this
	method and must be a sibling of 'view'.
	
	Margin is expressed as either a relative percent or as absolute
	points depending on the value of 'relative'.
	*/
	public func pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0.0, relative:Bool = false, debugMargin:Bool = false) {
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
		marginView.pin(toAxis: edge.axis == .y ? .x : .y, inView: parentview)
		
		if relative {
			// setup the relative dimension
			marginView.pin((edge.axis == .x) ? .width : .height, to: margin, ofView:parentview)
		}
		else {
			// setup the fixed dimensionz
			marginView.pin((edge.axis == .x) ? .width : .height, to: margin)
		}
		
		// pin the margin to the view
		marginView._pin(edge:edge, toView: view, toAnchor:anchorPoint)
		
		
		// when x or y center second anchor point, we can not fix
		// the margin view like this..
		let forceAnchor = anchorPoint == .centerX || anchorPoint == .centerY
		
		if forceAnchor {
			_pin(edge: edge, toView: marginView, toAnchor:edge.inverted, margin:margin)
		}
		else {
			
			// pin ourselves to the margin..
			_pin(edge: edge, toView: marginView, toAnchor:(anchor == nil) ? anchorPoint.inverted : anchor)
		}
	}
	
	/**
	Add Pin to constrain our vertical or horizontal axis.
	
	- Author:
	- returns:
	- throws:
	
	- parameters:
		- toAxis: the axis to pin to.
		- view: the view who's toAxis we are pinned to.
		- offset: the amount we are offset from the axis. expressed in points.
	
	- Important:
	Self must already have a superview before calling this
	method and must be a sibling of 'view'.
	*/
	public func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat = 0) {
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
		let constraint = NSLayoutConstraint(item: self, attribute: toAxis.attribute,
		                                    relatedBy: .equal,
		                                    toItem: view, attribute: toAxis.attribute,
		                                    multiplier: 1.0, constant: offset)
		view.addConstraint(constraint)
	}
	
	/**
	Add Pin to constrain the dimensions of a UIView relative to the size
	of 'view'.
	
	- Author:
	- returns:
	- throws:
	
	- parameters:
		- dimension: the dimension to pin.
		- to: a percent of 'view's size in in the range of 0.0->1.0.
		- view: the view who's dimensions we are relative to.
		- aspectRatio: an aspect ratio to apply to this view. defaults does not maintain any aspect ratio.
	
	- Important:
	Self must already have a superview before calling this
	method and must be a sibling of 'view'.
	*/
	public func pin(_ dimension:PinDimension, to percent:CGFloat, ofView view:UIView, aspectRatio aspect:CGFloat? = nil) {
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
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
	
	
	/**
	Add Pin to constrain the dimensions of a UIView.
	
	- Author:
	- returns:
	- throws:
	
	- parameters:
		- dimension: the dimension to pin.
		- to: the dimension expressed in points.
		- aspectRatio: an aspect ratio to apply to this view. defaults does not maintain any aspect ratio.
	
	- Important:
	Self must already have a superview before calling this
	method.
	*/
	public func pin(_ dimension:PinDimension, to value:CGFloat, aspectRatio aspect:CGFloat? = nil) {
		assert(superview != nil, "view must have a superview")
		
		let constraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                    relatedBy: .equal,
		                                    toItem: nil, attribute: .notAnAttribute,
		                                    multiplier: 1.0, constant: value)
		addConstraint(constraint)
		
		if let aspect = aspect {
			let aspectconstraint = NSLayoutConstraint(item: self, attribute: dimension.inverted.attribute,
			                                          relatedBy: .equal,
			                                          toItem: self, attribute: dimension.attribute,
			                                          multiplier: dimension == .width ? 1/aspect : aspect, constant: 0)
			addConstraint(aspectconstraint)
		}
	}
	
	// private
	private func _pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0) {
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
