//
//  UIView+Pinnable.swift
//  Pinnable
//
//  Created by Joey Patino on 10/3/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

extension UIView : Pinnable {}
public extension Pinnable where Self : UIView {
	
	/**
	Add Pin to constrain the edge of a UIView to the edge of another
	view.
	
	- Author:
	- returns:
		a Pin instance
	- throws:
	
	- parameters:
		- edge: the edge of this view to pin.
		- view: the view to pin this view to.
		- anchor: the edge of 'view' to pin this view to. defaults to 'edge'
		- margin: the margin between the views, expressed as either a relative percentage of the the current superview or absolute points. defaults to 0
		- relative: is the margin relative to the superviews bounds. defaults to false
	
	- Important:
	Self must already have a superview before calling this method and must be a sibling of 'view'.
	*/
	public func pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0.0, relative:Bool = false) -> Pin {
		assert(superview != nil, "PinHierarchyException - \(self) must have a superview before being pinned")
		assert(view.isDescendant(of: superview!), "PinHierarchyException - relativeTo view must be a sibling of \(self)")
		
		return _pin(edge: edge, toView: view,
		            toAnchor: anchor,
		            margin: margin,
		            relative: relative, debugMargin: false)
	}
	
	/**
	Add Pin to constrain our vertical or horizontal axis.
	
	- Author:
	- returns:
		a Pin instance.
	- throws:
	
	- parameters:
		- toAxis: the axis to pin to.
		- view: the view who's toAxis we are pinned to.
		- offset: the amount we are offset from the axis. expressed in points.
	
	- Important:
	Self must already have a superview before calling this method and must be a sibling of 'view'.
	*/
	public func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat = 0) -> Pin {
		assert(superview != nil, "PinHierarchyException - \(self) must have a superview before being pinned")
		assert(view.isDescendant(of: superview!), "PinHierarchyException - relativeTo view must be a sibling of \(self)")

		return _pin(toAxis:toAxis, inView:view, offset:offset)
	}
	
	/**
	Add Pin to constrain the dimensions of a UIView relative to the size
	of 'view'.
	
	- Author:
	- returns:
		a Pin instance.
	- throws:
	
	- parameters:
		- dimension: the dimension to pin.
		- to: the sie to make the view, expressed as either a relative percentage of relativeToView or in absolute points.
		- view: the view who's dimensions we are relative to.
		- aspectRatio: an aspect ratio to apply to this view. defaults does not maintain any aspect ratio.
	
	- Important:
	Self must already have a superview before calling this method and must be a sibling of 'relativeToView' if specified
	*/
	public func pin(dimension:PinDimension, to value:CGFloat, relativeTo view:UIView? = nil, aspectRatio aspect:CGFloat? = nil) -> Pin {
		assert(superview != nil, "PinHierarchyException - \(self) must have a superview before being pinned")
		if view != nil {
			assert(view != nil && view!.isDescendant(of: superview!), "PinHierarchyException - relativeTo view must be a sibling of \(self)")
		}

		return _pin(dimension: dimension, to: value, relativeTo:view, aspectRatio: aspect)
	}
}

fileprivate extension Pinnable where Self : UIView {
	
	fileprivate func _pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0.0, relative:Bool = false, debugMargin:Bool = false) -> Pin {
		let anchorPoint = anchor ?? edge
		let parentview = superview!
		translatesAutoresizingMaskIntoConstraints = false
		
		var generatedPins:[Pin] = []

		let useRelativeMargin = anchorPoint != .centerX && anchorPoint != .centerY

		if useRelativeMargin {
			assert(relative && margin > 0.0, "PinInvalidParameterError - relative margin can not be zero. use a fixed margin instead")

			let marginView = MarginView(forView: self)
			marginView.backgroundColor = debugMargin ? .red : .clear
			parentview.addSubview(marginView)
			
			// pin the width or height as needed..
			generatedPins.append(marginView._pin(dimension:(edge.axis == .x) ? .height : .width, to: 1.0))
			
			// center in the parent view..
			generatedPins.append(marginView._pin(toAxis: edge.axis == .y ? .x : .y, inView: parentview))
			
			// setup the relative or fixed dimension
			relative
				? generatedPins.append(marginView._pin(dimension:(edge.axis == .x) ? .width : .height, to: margin, relativeTo:parentview))
				: generatedPins.append(marginView._pin(dimension:(edge.axis == .x) ? .width : .height, to: margin))
			
			// pin the margin to the view
			generatedPins.append(marginView._pin(edge:edge, toView: view, ancestorView: parentview, toAnchor:anchorPoint, margin:0))

			// pin the view to the margin..
			generatedPins.append(_pin(edge: edge, toView: marginView,
			                          ancestorView: parentview, toAnchor:anchorPoint.inverted,
			                          margin:0))

		}
		else {
			if relative {
				print("PinInvalidParameterError - relative margins do not work when pinned to a center point. call `func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat) -> Pin` instead")
			}
			generatedPins.append(_pin(edge: edge, toView: parentview,
			                          ancestorView: parentview, toAnchor:anchorPoint.inverted,
			                          margin:margin))
		}

		return Pin(edge:edge, pins:generatedPins, isRelativePin:useRelativeMargin)
	}
	
	fileprivate func _pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat = 0) -> Pin {
		let constraint = view._constrain(toAxis, ofView: self,
		                                 to: toAxis, ofView: view,
		                                 constant: offset, multiplier: 1.0)
		
		return Pin(axis: toAxis, constraints:[constraint])
	}
	
	fileprivate func _pin(dimension:PinDimension, to value:CGFloat, relativeTo view:UIView? = nil, aspectRatio aspect:CGFloat? = nil) -> Pin {

		let isRelative = view != nil
		let constant = isRelative ? 0 : value
		let multiplier = isRelative ? value : 1.0
		let toItem = isRelative ? dimension : .none
		let constrainingView = isRelative ? view : self

		var constraints:[NSLayoutConstraint] = []
		if let constraint1 = constrainingView?._constrain(dimension, ofView: self,
		                                                  to: toItem, ofView: view,
		                                                  constant: constant, multiplier: multiplier){
			constraints.append(constraint1)
		}
		
		if let aspect = aspect {
			let constraint2 = _constrain(dimension.inverted, ofView: self,
			                             to: dimension, ofView: self,
			                             constant: 0, multiplier: (dimension == .width) ? 1/aspect : aspect)
			constraints.append(constraint2)
		}

		return Pin(dimension: dimension, constraints:constraints, isRelativePin:isRelative)
	}
	
	
	private func _pin(edge:PinEdge, toView view:UIView, ancestorView ancestor:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat) -> Pin {
		let constraint = ancestor._constrain(edge, ofView: self,
		                                     to: anchor ?? edge, ofView: view,
		                                     constant: margin, multiplier: 1.0)
		
		return Pin(edge: edge, constraints:[constraint])
	}
	
	private func _constrain<Attribute:PinAttribute>(_ fromAttribute:Attribute, ofView of:UIView, to toAttribute:Attribute, ofView to:UIView?, constant:CGFloat, multiplier:CGFloat = 1.0) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: of, attribute: fromAttribute.attribute,
		                                    relatedBy: .equal,
		                                    toItem: to, attribute: toAttribute.attribute,
		                                    multiplier: multiplier, constant: constant)
		addConstraint(constraint)
		
		return constraint
	}
}

extension NSLayoutConstraint {
	
	/**
	https://stackoverflow.com/questions/19593641/can-i-change-multiplier-property-for-nslayoutconstraint
	Change multiplier constraint
	
	- parameter multiplier: CGFloat
	- returns: NSLayoutConstraint
	*/
	func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
		
		NSLayoutConstraint.deactivate([self])
		
		let newConstraint = NSLayoutConstraint(
			item: firstItem as Any,
			attribute: firstAttribute,
			relatedBy: relation,
			toItem: secondItem,
			attribute: secondAttribute,
			multiplier: multiplier,
			constant: constant)
		
		newConstraint.priority = priority
		newConstraint.shouldBeArchived = self.shouldBeArchived
		newConstraint.identifier = self.identifier
		
		NSLayoutConstraint.activate([newConstraint])
		return newConstraint
	}
}
