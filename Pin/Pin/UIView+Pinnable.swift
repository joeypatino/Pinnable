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
	Add a Pin to constrain the edge of a UIView to the edge of another
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
	@discardableResult
	func pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0.0, relative:Bool = false) -> Pin {
		assert(superview != nil, "PinHierarchyException - \(self) must have a superview before being pinned")
		assert(view.isDescendant(of: superview!), "PinHierarchyException - relativeTo view must be a sibling of \(self)")

		return _pin(edge: edge, toView: view,
		            toAnchor: anchor,
		            margin: margin,
		            relative: relative, debugMargin: false)
	}
	
	/**
	Add a Pin to constrain our vertical or horizontal axis.
	
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
	@discardableResult
	func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat = 0) -> Pin {
		assert(superview != nil, "PinHierarchyException - \(self) must have a superview before being pinned")
		assert(view.isDescendant(of: superview!), "PinHierarchyException - relativeTo view must be a sibling of \(self)")

		return _pin(toAxis:toAxis, inView:view, offset:offset)
	}
	
	/**
	Add a Pin to constrain the dimensions of a UIView relative to the size
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
	@discardableResult
	func pin(dimension:PinDimension, to value:CGFloat, relativeTo view:UIView? = nil, aspectRatio aspect:CGFloat? = nil) -> Pin {
		assert(superview != nil, "PinHierarchyException - \(self) must have a superview before being pinned")
		if view != nil {
			assert(view != nil && view!.isDescendant(of: superview!), "PinHierarchyException - relativeTo view must be a sibling of \(self)")
		}

		return _pin(dimension: dimension, to: value, relativeTo:view, aspectRatio: aspect)
	}
}

fileprivate extension Pinnable where Self : UIView {
	
	@discardableResult
	func _pin(edge:PinEdge, toView view:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat = 0.0, relative:Bool = false, debugMargin:Bool = false) -> Pin {
		let anchorPoint = anchor ?? edge
		let parentview = superview!
		translatesAutoresizingMaskIntoConstraints = false
		
		var generatedPins:[Pin] = []

		let nonRelativeEdges:[PinEdge] = [.centerX, .centerY]
		let useRelativeMargin = !nonRelativeEdges.contains(anchorPoint)

		if useRelativeMargin {

			let marginView = MarginView(forView: self)
			marginView.backgroundColor = debugMargin ? .red : .clear
			parentview.addSubview(marginView)

			// in order to prevent invalid constraints when the Pin is disabled, we apply a
			// general set of low priority constraints. The view will fall back to these constraints
			// when the pin is disabled.
			if #available(iOS 9.0, *) {
				let top = marginView.topAnchor.constraint(equalTo: parentview.topAnchor)
				let leading = marginView.leadingAnchor.constraint(equalTo: parentview.leadingAnchor)
				let width = marginView.widthAnchor.constraint(equalToConstant: 0)
				let height = marginView.heightAnchor.constraint(equalToConstant: 0)
				[top, leading, width, height].forEach { $0.priority = UILayoutPriority.defaultLow; $0.isActive = true }
			}

			// pin the width or height as needed..
			let fixedDimension:PinDimension = (edge.axis == .x) ? .height : .width
			generatedPins.append(marginView._pin(dimension: fixedDimension, to: 1.0))

			// center in the parent view..
            generatedPins.append(marginView._pin(edge: edge.axis == .y ? .centerX : .centerY, toView: self))

			// setup the relative or fixed dimension
			let dimensionToPin:PinDimension = (edge.axis == .x) ? .width : .height
			relative
				? generatedPins.append(marginView._pin(dimension: dimensionToPin, to: margin, relativeTo:parentview))
				: generatedPins.append(marginView._pin(dimension: dimensionToPin, to: margin))

            let isTopDownPin = edge == .top && anchorPoint == .bottom
            let isLeftRightPin = edge == .leading && anchorPoint == .trailing

			// pin the margin to the view
			generatedPins.append(marginView._pin(edge: edge,
                                                 toView: view,
                                                 ancestorView: parentview,
                                                 toAnchor: anchorPoint,
                                                 margin:0))
			// pin the view to the margin..
			generatedPins.append(_pin(edge: edge, toView: marginView,
                                      ancestorView: parentview,
									  toAnchor: (isTopDownPin || isLeftRightPin) ? anchorPoint : anchorPoint.inverted,
			                          margin:0))
		}
		else {
			if relative {
				print("PinInvalidParameterError - relative margins do not work when pinned to a center point. call `func pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat) -> Pin` instead")
			}
			generatedPins.append(_pin(edge: edge, toView: view,
                                      ancestorView: parentview, toAnchor:anchorPoint.inverted,
			                          margin:margin))
		}

		return Pin(edge:edge, pins:generatedPins, isRelative:useRelativeMargin)
	}
	
	@discardableResult
	func _pin(toAxis:PinAxis, inView view:UIView, offset:CGFloat = 0) -> Pin {
		let constraint = view.constraint(from: toAxis, on: self,
		                                 to: toAxis, on: view,
		                                 constant: offset, multiplier: 1.0)
		
		return Pin(axis: toAxis, constraints:[constraint])
	}
	
	@discardableResult
	func _pin(dimension:PinDimension, to value:CGFloat, relativeTo view:UIView? = nil, aspectRatio aspect:CGFloat? = nil) -> Pin {

		let isRelative = view != nil
		let constant = isRelative ? 0 : value
		let multiplier = isRelative ? value : 1.0
		let toItem = isRelative ? dimension : .none
		let constrainingView = isRelative ? view : self

		var constraints:[NSLayoutConstraint] = []
		if let constraint1 = constrainingView?.constraint(from: dimension, on: self,
		                                                  to: toItem, on: view,
		                                                  constant: constant, multiplier: multiplier){
			constraints.append(constraint1)
		}
		
		if let aspect = aspect {
			let constraint2 = constraint(from: dimension.inverted, on: self,
			                             to: dimension, on: self,
			                             constant: 0, multiplier: (dimension == .width) ? 1/aspect : aspect)
			constraints.append(constraint2)
		}

		return Pin(dimension: dimension, constraints:constraints, isRelative:isRelative)
	}
	
	@discardableResult
	func _pin(edge:PinEdge, toView view:UIView, ancestorView ancestor:UIView, toAnchor anchor:PinEdge? = nil, margin:CGFloat) -> Pin {
		let constraint = ancestor.constraint(from: edge, on: self,
		                                     to: anchor ?? edge, on: view,
		                                     constant: margin, multiplier: 1.0)
		return Pin(edge: edge, constraints:[constraint])
	}
	
	@discardableResult
	private func constraint<Attribute:PinAttribute>(from:Attribute, on view:UIView, to toAttribute:Attribute, on toView:UIView?, constant:CGFloat, multiplier:CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: from.attribute,
                                            relatedBy: .equal,
                                            toItem: toView, attribute: toAttribute.attribute,
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
