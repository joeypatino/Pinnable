//
//  ViewController.swift
//  Pinnable
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var aspectControl:Pin?
	var widthConstraint:Pin?
	var heightConstraint:Pin?
	var generatedPins:[Pin] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		generatePinnedViews()
	}
	
	private func layoutRelativeInsetViews() {
		/**
		* Stacked inset views with relative margins
		* Demonstrating how to stack and inset multiple views
		*/
		
		let c_1 = generateView()
		c_1.pin(edge: .top, toView: view)
		c_1.pin(edge:.trailing, toView: view)
		c_1.pin(edge:.bottom, toView: view)
		c_1.pin(edge:.leading, toView: view)
		
		let c_2 = generateView()
		c_1.addSubview(c_2)
		c_2.pin(edge:.top, toView: c_1, margin: 0.2, relative: true)
		c_2.pin(edge:.trailing, toView: c_1, margin: 0.2, relative: true)
		c_2.pin(edge:.bottom, toView: c_1, margin: 0.2, relative: true)
		c_2.pin(edge:.leading, toView: c_1, margin: 0.2, relative: true)
		
		let c_3 = generateView()
		c_2.addSubview(c_3)
		c_3.pin(edge:.top, toView: c_2, margin: 0.2, relative: true)
		c_3.pin(edge:.trailing, toView: c_2, margin: 0.2, relative: true)
		c_3.pin(edge:.bottom, toView: c_2, margin: 0.2, relative: true)
		c_3.pin(edge:.leading, toView: c_2, margin: 0.2, relative: true)
	}
	
	private func layoutAbsoluteMarginViews() {
		/**
		* Absolute Margins
		* Create and add views using absolute margins. Margins are expressed
		* in points..
		*/
		
		let top_2 = generateView()
		top_2.pin(dimension:.width, to: 20)
		top_2.pin(dimension:.height, to: 20)
		top_2.pin(edge:.top, toView: view, margin: 40)
		top_2.pin(toAxis: .x, inView: view)
		
		let bot_2 = generateView()
		bot_2.pin(dimension:.width, to: 20)
		bot_2.pin(dimension:.height, to: 20)
		bot_2.pin(edge:.bottom, toView: view, margin: 40)
		bot_2.pin(toAxis: .x, inView: view)
		
		let lead_2 = generateView()
		lead_2.pin(dimension:.width, to: 20)
		lead_2.pin(dimension:.height, to: 20)
		lead_2.pin(edge:.leading, toView: view, margin: 40)
		lead_2.pin(toAxis: .y, inView: view)
		
		let trail_2 = generateView()
		trail_2.pin(dimension:.width, to: 20)
		trail_2.pin(dimension:.height, to: 20)
		trail_2.pin(edge:.trailing, toView: view, margin: 40)
		trail_2.pin(toAxis: .y, inView: view)
	}

	private func layoutRelativeMarginViews() {
		/**
		* Relative Margins
		* Creates and adds views using margins that are relative to
		* the size of their superview. Relative margin values are
		* expressed in percentage of the superview's bounds.
		*/

		let top_1 = generateView()
		top_1.pin(dimension:.width, to: 40)
		top_1.pin(dimension:.height, to: 40)
		top_1.pin(edge:.top, toView: view, margin: 0.20, relative: true)
		top_1.pin(toAxis: .x, inView: view)
		
		let bot_1 = generateView()
		bot_1.pin(dimension:.width, to: 40)
		bot_1.pin(dimension:.height, to: 40)
		bot_1.pin(edge:.bottom, toView: view, margin: 0.20, relative:true)
		bot_1.pin(toAxis: .x, inView: view)
		
		let lead_1 = generateView()
		lead_1.pin(dimension:.width, to: 40)
		lead_1.pin(dimension:.height, to: 40)
		lead_1.pin(edge:.leading, toView: view, margin: 0.20, relative:true)
		lead_1.pin(toAxis: .y, inView: view)
		
		let trail_1 = generateView()
		trail_1.pin(dimension:.width, to: 40)
		trail_1.pin(dimension:.height, to: 40)
		trail_1.pin(edge:.trailing, toView: view, margin: 0.20, relative:true)
		trail_1.pin(toAxis: .y, inView: view)
		
		/**
		* Pinned to random views
		* Demonstrating how to pin to arbitrary views and
		* to arbitrary view edges or axis'
		*/
		let r_1 = generateView()
		r_1.backgroundColor = .black
		r_1.pin(dimension:.width, to: 80)
		r_1.pin(dimension:.height, to: 80)
		r_1.pin(edge: .top, toView: top_1, toAnchor: .bottom, margin: 0.20, relative:true)
		r_1.pin(toAxis: .x, inView: view)
		
		
		// Controlling constraints with Pins
		let r_8 = generateView()
		r_8.pin(edge: .bottom, toView: bot_1, toAnchor: .top, margin: 10)
		r_8.pin(toAxis: .x, inView: view)

		aspectControl = r_8.pin(dimension: .width, to: 0.5, relativeTo: view, aspectRatio: 16.0/9.0)
		aspectControl?.isActive = !traitCollection.isiPhoneLandscape
		
		widthConstraint = r_8.pin(dimension: .width, to: 1.0, relativeTo: view)
		widthConstraint?.isActive = traitCollection.isiPhoneLandscape
		
		heightConstraint = r_8.pin(dimension: .height, to: 60)
		heightConstraint?.isActive = traitCollection.isiPhoneLandscape
	}
	
	private func generatePinnedViews(){
		
		layoutRelativeInsetViews()
		layoutAbsoluteMarginViews()
		layoutRelativeMarginViews()
	}
	
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		super.willTransition(to: newCollection, with: coordinator)

		// disable all constraints first before enabling the needed ones
		aspectControl?.isActive = false
		widthConstraint?.isActive = false
		heightConstraint?.isActive = false

		aspectControl?.isActive = !newCollection.isiPhoneLandscape
		widthConstraint?.isActive = newCollection.isiPhoneLandscape
		heightConstraint?.isActive = newCollection.isiPhoneLandscape
	}
	
	private func generateView() -> UIView {
		let randomView = UIView()
		randomView.backgroundColor = UIColor.random()
		view.addSubview(randomView)
		return randomView
	}
}

internal extension CGFloat {
	static func random() -> CGFloat {
		return CGFloat(arc4random()) / CGFloat(UInt32.max)
	}
}

internal extension UIColor {
	static func random() -> UIColor {
		return UIColor(red:   .random(),
		               green: .random(),
		               blue:  .random(),
		               alpha: 1.0)
	}
}

extension UITraitCollection {
	
	class public var iPhoneLandscapeTraits:[UITraitCollection] {
		let hR = UITraitCollection(horizontalSizeClass: .regular)
		let vC = UITraitCollection(verticalSizeClass: .compact)
		let hC = UITraitCollection(horizontalSizeClass: .compact)
		let landscapeBig = UITraitCollection(traitsFrom: [hR, vC])
		let landscapeSmall = UITraitCollection(traitsFrom: [hC, vC])
		return [landscapeBig, landscapeSmall]
	}
	public var isiPhoneLandscape:Bool {
		
		for trait in UITraitCollection.iPhoneLandscapeTraits {
			if containsTraits(in: trait) || containsTraits(in: trait) {
				return true
			}
		}
		return false
	}
}

