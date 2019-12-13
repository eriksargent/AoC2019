//
//  Int.swift
//  AOC19
//
//  Created by Erik Sargent on 12/10/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


extension Int {
	/// Returns the greatest common denominator between the receiver and other
	func gcd(with other: Int) -> Int {
		if other == 0 {
			return self
		}
		
		var (first, second) = (self, other)
		while second != 0 {
			(first, second) = (second, first % second)
		}
		return first
	}
	
	func lcm(with other: Int) -> Int {
		return self / self.gcd(with: other) * other
	}
	
	func limitTo(range: ClosedRange<Int>) -> Int {
		return Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
	}
}
