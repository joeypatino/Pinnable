//
//  Extensions.swift
//  Pin
//
//  Created by Joey Patino on 10/3/17.
//  Copyright © 2017 Joseph Patino. All rights reserved.
//

import UIKit

extension CGFloat {
	static func random() -> CGFloat {
		return CGFloat(arc4random()) / CGFloat(UInt32.max)
	}
}

extension UIColor {
	static func random() -> UIColor {
		return UIColor(red:   .random(),
		               green: .random(),
		               blue:  .random(),
		               alpha: 1.0)
	}
}
