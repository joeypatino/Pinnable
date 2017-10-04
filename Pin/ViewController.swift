//
//  ViewController.swift
//  Pinnable
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var generatedPins:[Pin] = []
	override func viewDidLoad() {
		super.viewDidLoad()
		
		layoutViewsWithPin()
	}
	
	private func layoutViewsWithPin(){
		
		/**
		* Stacked inset views
		* Demonstrating how to stack and inset multiple views

		let c_1 = generateView()
		c_1.pin(edge:.top, toView: view)
		c_1.pin(edge:.trailing, toView: view)
		c_1.pin(edge:.bottom, toView: view)
		c_1.pin(edge:.leading, toView: view)
		
		let c_2 = generateView()
		c_1.addSubview(c_2)
		c_2.pin(edge:.top, toView: c_1, margin: 0.1, relative: true)
		c_2.pin(edge:.trailing, toView: c_1, margin: 0.1, relative: true)
		c_2.pin(edge:.bottom, toView: c_1, margin: 0.1, relative: true)
		c_2.pin(edge:.leading, toView: c_1, margin: 0.1, relative: true)
		
		let c_3 = generateView()
		c_2.addSubview(c_3)
		c_3.pin(edge:.top, toView: c_2, margin: 0.1, relative: true)
		c_3.pin(edge:.trailing, toView: c_2, margin: 0.1, relative: true)
		c_3.pin(edge:.bottom, toView: c_2, margin: 0.1, relative: true)
		c_3.pin(edge:.leading, toView: c_2, margin: 0.1, relative: true)
		
		let c_4 = generateView()
		c_3.addSubview(c_4)
		c_4.pin(edge:.top, toView: c_3, margin: 0.1, relative: true)
		c_4.pin(edge:.trailing, toView: c_3, margin: 0.1, relative: true)
		c_4.pin(edge:.bottom, toView: c_3, margin: 0.1, relative: true)
		c_4.pin(edge:.leading, toView: c_3, margin: 0.1, relative: true)
		*/
		
		/**
		* Relative Margins
		* Creates and adds views using margins that are relative to
		* the size of their superview. Relative margin values are
		* expressed in percentage of the superview's bounds.

		let top_1 = generateView()
		top_1.pin(.width, to: 40)
		top_1.pin(.height, to: 40)
		top_1.pin(edge:.top, toView: view, margin: 0.20, relative: true)
		top_1.pin(toAxis: .x, inView: view)
		
		let bot_1 = generateView()
		bot_1.pin(.width, to: 40)
		bot_1.pin(.height, to: 40)
		bot_1.pin(edge:.bottom, toView: view, margin: 0.20, relative:true)
		bot_1.pin(toAxis: .x, inView: view)
		
		let lead_1 = generateView()
		lead_1.pin(.width, to: 40)
		lead_1.pin(.height, to: 40)
		lead_1.pin(edge:.leading, toView: view, margin: 0.20, relative:true)
		lead_1.pin(toAxis: .y, inView: view)
		
		let trail_1 = generateView()
		trail_1.pin(.width, to: 40)
		trail_1.pin(.height, to: 40)
		trail_1.pin(edge:.trailing, toView: view, margin: 0.20, relative:true)
		trail_1.pin(toAxis: .y, inView: view)
		*/
		
		/**
		* Absolute Margins
		* Create and add views using absolute margins. Margins are expressed
		* in points..

		let top_2 = generateView()
		top_2.pin(.width, to: 20)
		top_2.pin(.height, to: 20)
		top_2.pin(edge:.top, toView: view, margin: 40)
		top_2.pin(toAxis: .x, inView: view)
		
		let bot_2 = generateView()
		bot_2.pin(.width, to: 40)
		bot_2.pin(.height, to: 40)
		bot_2.pin(edge:.bottom, toView: view, margin: 30)
		bot_2.pin(toAxis: .x, inView: view)
		
		let lead_2 = generateView()
		lead_2.pin(.width, to: 60)
		lead_2.pin(.height, to: 60)
		lead_2.pin(edge:.leading, toView: view, margin: 40)
		lead_2.pin(toAxis: .y, inView: view)
		
		let trail_2 = generateView()
		trail_2.pin(.width, to: 80)
		trail_2.pin(.height, to: 80)
		trail_2.pin(edge:.trailing, toView: view, margin: 50)
		trail_2.pin(toAxis: .y, inView: view)
		*/
		
		/**
		* Pinned to random views
		* Demonstrating how to pin to arbitrary views and
		* to arbitrary view edges or axis'


		let r_1 = generateView()
		r_1.pin(.width, to: 50)
		r_1.pin(.height, to: 50)
		r_1.pin(edge:.top, toView: top_1, toAnchor: .bottom, margin: 0.20, relative:true)
		r_1.pin(toAxis: .x, inView: view)

		let r_2 = generateView()
		r_2.pin(.width, to: 50)
		r_2.pin(.height, to: 50)
		r_2.pin(edge:.leading, toView: r_1, toAnchor: .leading, margin: 20)
		r_2.pin(toAxis: .y, inView: view)

		let r_3 = generateView()
		r_3.pin(.width, to: 50)
		r_3.pin(.height, to: 50)
		r_3.pin(edge:.bottom, toView: r_2, toAnchor: .top, margin: 10)
		r_3.pin(edge:.leading, toView: r_2, toAnchor: .leading, margin: 0)
		
		let r_4 = generateView()
		r_4.pin(.width, to: 50)
		r_4.pin(.height, to: 50)
		r_4.pin(edge:.leading, toView: top_1, toAnchor: .centerX, margin: 0)
		r_4.pin(edge:.top, toView: top_1, toAnchor: .centerY, margin: 100)
		
		let r_5 = generateView()
		r_5.pin(.height, to: 0.5, ofView: view)
		r_5.pin(edge:.leading, toView: view, margin: 0.05, relative:true)
		r_5.pin(edge:.top, toView: view, margin: 0.05, relative:true)
		r_5.pin(edge:.trailing, toView: view, margin: 0.05, relative:true)

		let r_6 = generateView()
		r_6.pin(.width, to: 25)
		r_6.pin(.height, to: 25)
		r_6.pin(edge:.centerX, toView: bot_1, toAnchor: .centerX, margin: 40)
		r_6.pin(edge:.bottom, toView: bot_1, toAnchor: .top, margin: 0)

		let r_7 = generateView()
		r_7.pin(.width, to: 50)
		r_7.pin(.height, to: 50)
		r_7.pin(edge:.leading, toView: top_1, toAnchor: .centerX, margin: 0.25, relative:true)
		r_7.pin(edge:.top, toView: top_1, toAnchor: .centerY, margin: 0.25, relative:true)
		*/

		// Aspect ratios
		let r_8 = generateView()
		generatedPins.append(r_8.pin(dimension: .width, to: 0.5, relativeTo: view, aspectRatio: 16.0/9.0))
		generatedPins.append(r_8.pin(edge: .bottom, toView: view, toAnchor: .bottom, margin: 0.15, relative:true))
		generatedPins.append(r_8.pin(toAxis: .x, inView: view))
	}
	
	private func generateView() -> UIView {
		let randomView = UIView()
		addGesture(toView: randomView)
		randomView.backgroundColor = UIColor.random()
		view.addSubview(randomView)
		return randomView
	}
	
	/**
	* Add a gesture to test actions on the Pins
	*/
	private func addGesture(toView view: UIView) {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc private func viewTouched(gesture:UITapGestureRecognizer) {
		for pin in generatedPins {
			pin.isActive = !pin.isActive
		}
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
