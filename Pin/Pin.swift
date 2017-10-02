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
}


/**
* A Pin for edges. Used when aligning UIViews to other
* sibling UIView's
*/
public enum PinEdge {
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
		}
	}
}

/**
* Private UIView used when creating layout margins
*
* Funky KVO is being used in order to track when the view
* that the margin is applied to is removed from the screen
* when this occurs, we want to make sure that we remove the
* margin view as well so we don't pollute the parent view
*
* considerations:: The margin view must be a sibling of the
* view that it is being used for. This is enforced in the Pin
* methods already but should be noted.
*
* This class could also fail if the subviews are removed
* from screen for any reason. If this is needed, then the
* views must be configured again when they are added back
* as subviews by using the Pin methods
*/
private class MarginView : UIView {
	
	private var attachedView:UIView?
	private var siblingLayers:[CALayer] = []
	private var kvoPath:String = #keyPath(UIView.layer.sublayers)
	private var kvoView:UIView? {
		didSet {
			if let oldView = oldValue {
				unWatch(view: oldView)
			}
			if let newView = kvoView {
				watch(view: newView)
			}
		}
	}
	
	convenience init(forView view:UIView) {
		self.init(frame:CGRect.zero)
		attachedView = view
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	private func watch(view:UIView) {
		view.addObserver(self, forKeyPath: kvoPath, options: [.prior, .new], context: nil)
	}
	
	private func unWatch(view:UIView) {
		view.removeObserver(self, forKeyPath: kvoPath)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

		guard
			let attachedLayer = attachedView?.layer,
			let watchedView = object as? UIView, keyPath == kvoPath, superview != nil
			else {return}
		
		if change?[NSKeyValueChangeKey.notificationIsPriorKey] as? Bool == true {
			siblingLayers = watchedView.layer.sublayers ?? []
		}
		else if let currentLayers = change?[NSKeyValueChangeKey.newKey] as? [CALayer] {

			let differenceSet = Set(siblingLayers).subtracting(Set(currentLayers))
			if differenceSet.contains(attachedLayer) {
				removeFromSuperview()
			}
		}
	}
	
	override func willMove(toSuperview newSuperview: UIView?) {
		super.willMove(toSuperview: newSuperview)
		kvoView = newSuperview
	}
	
	deinit {
		kvoView = nil
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
		marginView.pin((edge.axis == .x) ? .height : .width, to: 2)
		
		// center in the parent view..
		marginView.pin(onAxis: edge.axis == .y ? .x : .y, inView: parentview)
		
		if relative {
			// setup the relative dimension
			marginView.pin((edge.axis == .x) ? .width : .height, to: margin, ofView:parentview)
		}
		else {
			// setup the fixed dimension
			marginView.pin((edge.axis == .x) ? .width : .height, to: margin)
		}
		
		// pin the margin to the view
		marginView.pin(edge, toView: view, toAnchor:anchorPoint)
		
		// pin ourselves to the margin..
		pin(edge, toView: marginView, toAnchor:(anchor == nil) ? anchorPoint.inverted : anchor)
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
	
	public func pin(onAxis:PinAxis, inView view:UIView, withOffset offset:CGFloat = 0) {
		assert(superview != nil, "view must have a superview")
		assert(view.isDescendant(of: superview!), "view must be a decendant of the view")
		
		let constraint = NSLayoutConstraint(item: self, attribute: onAxis.attribute,
		                                    relatedBy: .equal,
		                                    toItem: view, attribute: onAxis.attribute,
		                                    multiplier: 1.0, constant: offset)
		view.addConstraint(constraint)
	}
	
	public func pin(_ dimension:PinDimension, to percent:CGFloat, ofView view:UIView) {
		let marginSizeConstraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                              relatedBy: .equal,
		                                              toItem: view, attribute: dimension.attribute,
		                                              multiplier: percent, constant: 0)
		view.addConstraint(marginSizeConstraint)
	}
	
	public func pin(_ dimension:PinDimension, to value:CGFloat) {
		let constraint = NSLayoutConstraint(item: self, attribute: dimension.attribute,
		                                    relatedBy: .equal,
		                                    toItem: nil, attribute: .notAnAttribute,
		                                    multiplier: 1.0, constant: value)
		addConstraint(constraint)
	}
}

