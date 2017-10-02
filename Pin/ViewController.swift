//
//  ViewController.swift
//  Pin
//
//  Created by Joey Patino on 10/2/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		layoutViewsWithPin()
	}
	
	private func layoutViewsWithPin(){
		
		/**
		* Relative Margins
		* Creates and adds views using margins that are relative to
		* the size of their superview. Relative margin values are
		* expressed in percentage of the superview's bounds.
		*/
		let top_1 = generateView()
		top_1.pin(.width, to: 80)
		top_1.pin(.height, to: 80)
		top_1.pin(.top, toView: view, margin: 0.10, relative: true)
		top_1.pin(onAxis: .x, inView: view)
		
		let bot_1 = generateView()
		bot_1.pin(.width, to: 60)
		bot_1.pin(.height, to: 60)
		bot_1.pin(.bottom, toView: view, margin: 0.20, relative:true)
		bot_1.pin(onAxis: .x, inView: view)
		
		let lead_1 = generateView()
		lead_1.pin(.width, to: 40)
		lead_1.pin(.height, to: 40)
		lead_1.pin(.leading, toView: view, margin: 0.30, relative:true)
		lead_1.pin(onAxis: .y, inView: view)
		
		let trail_1 = generateView()
		trail_1.pin(.width, to: 20)
		trail_1.pin(.height, to: 20)
		trail_1.pin(.trailing, toView: view, margin: 0.40, relative:true)
		trail_1.pin(onAxis: .y, inView: view)
		
		/**
		* Absolute Margins
		* Create and add views using absolute margins. Margins are expressed
		* in points..
		*/
		let top_2 = generateView()
		top_2.pin(.width, to: 20)
		top_2.pin(.height, to: 20)
		top_2.pin(.top, toView: view, margin: 40)
		top_2.pin(onAxis: .x, inView: view)
		
		let bot_2 = generateView()
		bot_2.pin(.width, to: 40)
		bot_2.pin(.height, to: 40)
		bot_2.pin(.bottom, toView: view, margin: 30)
		bot_2.pin(onAxis: .x, inView: view)
		
		let lead_2 = generateView()
		lead_2.pin(.width, to: 60)
		lead_2.pin(.height, to: 60)
		lead_2.pin(.leading, toView: view, margin: 40)
		lead_2.pin(onAxis: .y, inView: view)
		
		let trail_2 = generateView()
		trail_2.pin(.width, to: 80)
		trail_2.pin(.height, to: 80)
		trail_2.pin(.trailing, toView: view, margin: 50)
		trail_2.pin(onAxis: .y, inView: view)
		
		/**
		* Pinned to random views
		* Demonstrating how to pin to arbitrary views and
		* to arbitrary view edges or axis'

		let r_1 = generateView()
		r_1.pin(.width, to: 50)
		r_1.pin(.height, to: 50)
		r_1.pin(.top, toView: top_1, toAnchor: .bottom, margin: 0.20, relative:true)
		r_1.pin(onAxis: .x, inView: view)

		let r_2 = generateView()
		r_2.pin(.width, to: 50)
		r_2.pin(.height, to: 50)
		r_2.pin(.leading, toView: r_1, toAnchor: .leading, margin: 20)
		r_2.pin(onAxis: .y, inView: view)

		let r_3 = generateView()
		r_3.pin(.width, to: 50)
		r_3.pin(.height, to: 50)
		r_3.pin(.bottom, toView: r_2, toAnchor: .top, margin: 10)
		r_3.pin(.leading, toView: r_2, toAnchor: .leading, margin: 0)
		*/
	}
	
	private func generateView() -> UIView {
		let randomView = UIView()
		addGesture(toView: randomView)
		randomView.backgroundColor = UIColor.random()
		view.addSubview(randomView)
		return randomView
	}
	
	/**
	* Add a gesture to test out removing the view and ensuring
	* that the margin views (IN RED) are also removed and dealloc'd
	*/
	private func addGesture(toView view: UIView) {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTouched))
		view.addGestureRecognizer(tapGesture)
	}
	
	@objc private func viewTouched(gesture:UITapGestureRecognizer) {
		gesture.view?.removeFromSuperview()
	}
}
