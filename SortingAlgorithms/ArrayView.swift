//
//  ArrayView.swift
//  SortingAlgorithms
//
//  Created by Sean Groebe on 4/11/18.
//  Copyright © 2018 DePaul University. All rights reserved.
//

import UIKit

class ArrayView: UIView {
	@IBInspectable var color: UIColor = UIColor.green
	
	var data = [Int]()
	
	override func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else { return }
		// Calculates the size of the array and creates spacially accurate bar representations
		if data.count > 0 {
			let gap = 2
			let width = Int(bounds.width) / data.count - gap
			let height = Int(bounds.height) / data.count
			context.setFillColor(color.cgColor)
			for i in 0..<data.count {
				context.fill(CGRect(x: i * (width + gap), y: Int(bounds.height), width: width, height: -data[i] * height))
			}
		}
	}

}
