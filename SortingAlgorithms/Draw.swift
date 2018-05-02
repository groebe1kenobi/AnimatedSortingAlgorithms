//
//  Draw.swift
//  SortingAlgorithms
//
//  Created by Sean Groebe on 4/8/18.
//  Copyright © 2018 DePaul University. All rights reserved.
//

import UIKit

struct ArrayItem {
	let color: UIColor
	
	let height: Float
}

@IBDesignable
class Draw: UIView {
	let barWidth: CGFloat = 10.0
	
	let space: CGFloat = 10.0
	
	private let bottomSpace: CGFloat = 20.0
	private let topSpace: CGFloat = 20.0
	private let mainLayer: CALayer = CALayer()
	private let scrollView: UIScrollView = UIScrollView()
    
	var dataEntries: [ArrayItem]? = nil {
		didSet {
			mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
			
			if let dataEntries = dataEntries {
				scrollView.contentSize = CGSize(width: (barWidth+space)*CGFloat(dataEntries.count), height: self.frame.size.height)
				mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
				for i in 0..<dataEntries.count {
					showEntry(index: i, entry: dataEntries[i])
				}
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	convenience init() {
		self.init(frame: CGRect.zero)
		setupView()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	override func layoutSubviews() {
		scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
	}
	private func setupView() {
		scrollView.layer.addSublayer(mainLayer)
		self.addSubview(scrollView)
	}
	private func showEntry(index: Int, entry: ArrayItem) {
		//starting x position of bar
		let xPos: CGFloat = space + CGFloat(index) * (barWidth + space)
		
		//starting y position of bar
		let yPos: CGFloat = translateHeightValueToYPosition(value: entry.height)
		drawBar(xPos: xPos, yPos: yPos, color: entry.color)
		
	}
	
	private func drawBar(xPos: CGFloat, yPos: CGFloat, color: UIColor) {
		let barLayer = CALayer()
		barLayer.frame = CGRect(x: xPos, y:yPos, width: barWidth, height: mainLayer.frame.height - bottomSpace - yPos)
		barLayer.backgroundColor = color.cgColor
		mainLayer.addSublayer(barLayer)
	}
	private func translateHeightValueToYPosition(value: Float)-> CGFloat {
		let height: CGFloat = CGFloat(value) * (mainLayer.frame.height - bottomSpace - topSpace)
		return mainLayer.frame.height - bottomSpace - height
	}
	
}
