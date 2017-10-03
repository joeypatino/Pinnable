//
//  MarginView.swift
//  Pin
//
//  Created by Joey Patino on 10/3/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

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
internal class MarginView : UIView {
	
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
