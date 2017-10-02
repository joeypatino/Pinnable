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
		setupPins()
	}

	private func setupPins(){
		let top = UIView()
		top.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
		view.addSubview(top)
		top.pin(dimension: .width, to: 30)
		top.pin(dimension: .height, to: 30)
		top.pin(edge: .top, toView: view, margin: 0.25, isRelative: true)
		top.pin(centered: .horizontal, inView: view)
		
		let bot = UIView()
		bot.backgroundColor = UIColor.green.withAlphaComponent(0.5)
		view.addSubview(bot)
		bot.pin(dimension: .width, to: 40)
		bot.pin(dimension: .height, to: 40)
		bot.pin(edge: .bottom, toView: view, margin: 0.25, isRelative:true)
		bot.pin(centered: .horizontal, inView: view)
		
		let lead = UIView()
		lead.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
		view.addSubview(lead)
		lead.pin(dimension: .width, to: 50)
		lead.pin(dimension: .height, to: 50)
		lead.pin(edge: .leading, toView: view, margin: 0.25, isRelative:true)
		lead.pin(centered: .vertical, inView: view)
		
		let trail = UIView()
		trail.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
		view.addSubview(trail)
		trail.pin(dimension: .width, to: 60)
		trail.pin(dimension: .height, to: 60)
		trail.pin(edge: .trailing, toView: view, margin: 0.25, isRelative:true)
		trail.pin(centered: .vertical, inView: view)
		
		
		
		
		let top2 = UIView()
		top2.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
		view.addSubview(top2)
		top2.pin(dimension: .width, to: 60)
		top2.pin(dimension: .height, to: 60)
		top2.pin(edge: .top, toView: view, margin: 80, isRelative:false)
		top2.pin(centered: .horizontal, inView: view)
		
		let bot2 = UIView()
		bot2.backgroundColor = UIColor.green.withAlphaComponent(0.5)
		view.addSubview(bot2)
		bot2.pin(dimension: .width, to: 50)
		bot2.pin(dimension: .height, to: 50)
		bot2.pin(edge: .bottom, toView: view, margin: 80, isRelative:false)
		bot2.pin(centered: .horizontal, inView: view)
		
		let lead2 = UIView()
		lead2.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
		view.addSubview(lead2)
		lead2.pin(dimension: .width, to: 40)
		lead2.pin(dimension: .height, to: 40)
		lead2.pin(edge: .leading, toView: view, margin: 80, isRelative:false)
		lead2.pin(centered: .vertical, inView: view)
		
		let trail2 = UIView()
		trail2.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
		view.addSubview(trail2)
		trail2.pin(dimension: .width, to: 30)
		trail2.pin(dimension: .height, to: 30)
		trail2.pin(edge: .trailing, toView: view, margin: 80, isRelative:false)
		trail2.pin(centered: .vertical, inView: view)
		
		
		let op1 = UIView()
		op1.backgroundColor = .black
		view.addSubview(op1)
		op1.pin(dimension: .width, to: 50)
		op1.pin(dimension: .height, to: 50)
		op1.pin(edge: .top, toView: top, toAnchor: PinEdge.bottom, margin: 0.10, isRelative:true)
		op1.pin(centered: .horizontal, inView: view)
		
		
		let op2 = UIView()
		op2.backgroundColor = .green
		view.addSubview(op2)
		op2.pin(dimension: .width, to: 70)
		op2.pin(dimension: .height, to: 70)
		op2.pin(edge: .trailing, toView: op1, toAnchor: PinEdge.leading, margin: 90, isRelative:false)
		op2.pin(centered: .vertical, inView: view)
		
		let op3 = UIView()
		op3.backgroundColor = .black
		view.addSubview(op3)
		op3.pin(dimension: .width, to: 40)
		op3.pin(dimension: .height, to: 40)
		op3.pin(edge: .bottom, toView: op2, toAnchor: PinEdge.top, margin: 40)
		op3.pin(edge: .leading, toView: op2, toAnchor: PinEdge.leading, margin: 0)
	}
}

