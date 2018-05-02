//
//  ViewController.swift
//  SortingAlgorithms
//
//  Created by Sean Groebe on 4/8/18.
//  Copyright © 2018 DePaul University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var arraySize: UISegmentedControl!
	@IBOutlet weak var sortType2: UISegmentedControl!
	@IBOutlet weak var sortType1: UISegmentedControl!
	
	//Instances of the ArrayView class, which contains the .data
	//self.arrayView1/2.data communicates with the ArrayView class to
	//draw the different instance
	@IBOutlet weak var arrayView1: ArrayView!
	@IBOutlet weak var arrayView2: ArrayView!
	
	
	let delay: UInt32 = 100_000
	var N: Int = 16
	var currentAlgo1: String = "Insertion"
	var currentAlgo2: String = "Insertion"

	
	override func viewDidLoad() {
		super.viewDidLoad()
		arrayView1.color = UIColor.green
		arrayView2.color = UIColor.red
		reset()
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
	
	}
	@IBAction func arraySizeSelect(_ sender: UISegmentedControl) {
		switch arraySize.selectedSegmentIndex {
		case 0:
			N = 16
		case 1:
			N = 32
		case 2:
			N = 48
		case 3:
			N = 64
		default:
			N = 16
		}
		reset()
		
		// Since the change of N moves around the array items, the setNeedsDisplay() must be set on the main display
		DispatchQueue.main.async {
			self.arrayView1.setNeedsDisplay()
			self.arrayView2.setNeedsDisplay()
		}
	}
	
	// currentAlgo1/2 is set based off of the segmented index position.
	// These values are utilized when the sort button is pressed
	@IBAction func sortSelect1(_ sender: UISegmentedControl) {
		switch sortType1.selectedSegmentIndex {
		case 0:
			currentAlgo1 = "Insertion"
		case 1:
			currentAlgo1 = "Selection"
		case 2:
			currentAlgo1 = "Quicksort"
		case 3:
			currentAlgo1 = "Mergesort"
		default:
			currentAlgo1 = "Insertion"
		}
	}
	
	
	@IBAction func sortSelect2(_ sender: UISegmentedControl) {
		switch sortType2.selectedSegmentIndex {
		case 0:
			currentAlgo2 = "Insertion"
		case 1:
			currentAlgo2 = "Selection"
		case 2:
			currentAlgo2 = "Quicksort"
		case 3:
			currentAlgo2 = "Mergesort"
		default:
			currentAlgo2 = "Insertion"
		}
	}
	
	
	
	
	// called whenever the N value is changed, creates a random array of size N
	func reset() {
		arrayView1.data.removeAll()
		arrayView2.data.removeAll()
		
		for _ in 0..<N {
			let rand = Int(arc4random_uniform(UInt32(N)))
			arrayView1.data.append(rand)
			arrayView2.data.append(rand)
		}
	}
	
	
	@IBAction func sortAction(_ sender: UIButton) {
		// Create 2 seperate asynchronous threads for the two different sorting operations.
		// The reason the are .async is because the threads will be running concurrently with
		// setNeedsDisplay() on the main thread. If they were .sync, they would have to wait
		// for task ahead to complete
		DispatchQueue.global(qos: .userInitiated).async {
			switch self.currentAlgo1 {
			case "Insertion":
				self.insertionSort(&self.arrayView1.data)
			case "Selection":
				self.selectionSort(&self.arrayView1.data)
			case "Quicksort":
				self.quicksort(&self.arrayView1.data)
			case "MergeSort":
				self.mergeSort(&self.arrayView1.data)
			default:
				self.insertionSort(&self.arrayView1.data)
			}
		}
		
		DispatchQueue.global(qos: .userInitiated).async {
			switch self.currentAlgo2 {
			case "Insertion":
				self.insertionSort(&self.arrayView2.data)
			case "Selection":
				self.selectionSort(&self.arrayView2.data)
			case "Quicksort":
				self.quicksort(&self.arrayView2.data)
			case "MergeSort":
				self.mergeSort(&self.arrayView2.data)
			default:
				self.insertionSort(&self.arrayView2.data)
			}
		}
		
		DispatchQueue.main.async {
			self.arrayView1.setNeedsDisplay()
			self.arrayView2.setNeedsDisplay()
		}
	}
	
	
	// SORT ALGORITHMS
	
	
	//SELECTION SORT
	func selectionSort(_ arr: inout [Int]) {
		let len = arr.count
		for i in 0..<len {
			var min = i
			for j in i + 1..<len {
				if arr[j] < arr[min] {
					min = j
				}
			}
			arr.swapAt(i, min)
			DispatchQueue.main.async {
				self.arrayView1.setNeedsDisplay()
				self.arrayView2.setNeedsDisplay()
			}
			usleep(delay)
		}
	}
	
	//INSERTION SORT
	
	func insertionSort(_ arr: inout [Int]) {
		for i in 0..<arr.count {
			var j = i
			while j > 0 && arr[j-1] > arr[j] {
				arr.swapAt(j-1, j)
				j -= 1
				DispatchQueue.main.async {
					self.arrayView1.setNeedsDisplay()
					self.arrayView2.setNeedsDisplay()
				}
				usleep(delay)
				
			}
		}
	}
	
	//QUICKSORT
	

	func quicksort(_ arr: inout[Int]) {
		quicksort(&arr,  0, arr.count-1)
	}
	
	func quicksort(_ arr: inout [Int], _ start: Int, _ end: Int) {
		if start >= end { return }
		let partitionIndex = partition(&arr, start, end)
		quicksort(&arr, start, partitionIndex - 1)
		quicksort(&arr, partitionIndex + 1, end)
	}
	
	func partition(_ arr: inout [Int], _ start: Int, _ end: Int) -> Int {
		var pivot = start
		for i in start..<end {
			if arr[i] < arr[end] {
				arr.swapAt(pivot, i)
				pivot += 1
				DispatchQueue.main.async {
					self.arrayView1.setNeedsDisplay()
					self.arrayView2.setNeedsDisplay()
				}
				usleep(delay)
			}
		}
		arr.swapAt(pivot, end)
		DispatchQueue.main.async {
			self.arrayView1.setNeedsDisplay()
			self.arrayView2.setNeedsDisplay()
		}
		usleep(delay)
		
		return pivot
	}
	
	// MERGESORT
	func mergeSort(_ arr: inout [Int]){
		guard arr.count > 1 else {return}
		let mid = arr.count/2
		
		var left = [Int]()
		var right = [Int]()
		for x in 0..<mid {
			left.append(arr[x])
		}
		for y in mid..<arr.count {
			right.append(arr[y])
		}
		mergeSort(&left)
		DispatchQueue.main.async {
			self.arrayView1.setNeedsDisplay()
			self.arrayView2.setNeedsDisplay()
		}
		usleep(delay)
		mergeSort(&right)
		DispatchQueue.main.async {
			self.arrayView1.setNeedsDisplay()
			self.arrayView2.setNeedsDisplay()
		}
		usleep(delay)
		arr = merge(&left, &right)
		DispatchQueue.main.async {
			self.arrayView1.setNeedsDisplay()
			self.arrayView2.setNeedsDisplay()
		}
		usleep(delay)
	}
	
	func merge(_ leftArr: inout [Int], _ rightArr: inout [Int]) -> [Int] {
		var leftIndex = 0
		var rightIndex = 0
		
		var orderedArr = [Int]()
		
		while leftIndex < leftArr.count && rightIndex < rightArr.count {
			if leftArr[leftIndex] < rightArr[rightIndex] {
				orderedArr.append(leftArr[leftIndex])
				leftIndex += 1
			} else if leftArr[leftIndex] > rightArr[rightIndex] {
				orderedArr.append(rightArr[rightIndex])
				rightIndex += 1
			} else {
				orderedArr.append(leftArr[leftIndex])
				leftIndex += 1
				orderedArr.append(rightArr[rightIndex])
				rightIndex += 1
			}
		}
		
		while leftIndex < leftArr.count {
			orderedArr.append(leftArr[leftIndex])
			leftIndex += 1
		}
		
		while rightIndex < rightArr.count {
			orderedArr.append(rightArr[rightIndex])
			rightIndex += 1
		}
		return orderedArr
	}
	
	
	
	

}

