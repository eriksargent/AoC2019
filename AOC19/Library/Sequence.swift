//
//  Sequence.swift
//  AOC19
//
//  Created by Erik Sargent on 12/6/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


extension Sequence {
	/// Returns the first element of the sequence that satisfies the given predicate
	func first<T: Equatable>(where path: KeyPath<Element, T>, is value: T) -> Element? {
		return first { $0[keyPath: path] == value }
	}
	
	/// Returns the first element of the sequence is nil
	func firstEqualsNil<T>(child path: KeyPath<Element, T?>) -> Element? {
		return first { $0[keyPath: path] == nil }
	}
	
	/// Returns the first element of the sequence is not nil
	func firstNonNil<T>(child path: KeyPath<Element, T?>) -> Element? {
		return first { $0[keyPath: path] != nil }
	}
	
	/// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate
	func contains<T: Equatable>(where path: KeyPath<Element, T>, is value: T) -> Bool {
		return contains { $0[keyPath: path] == value }
	}
	
	func sum<T: AdditiveArithmetic>() -> T where Self.Element == T {
		return reduce(T.zero, +)
	}
}


extension RandomAccessCollection {
	func indicies<T: Equatable>(where path: KeyPath<Element, T>, is value: T) -> [Int] {
		return enumerated().filter({ $0.element[keyPath: path] == value }).map({ $0.offset })
	}
}


extension Array where Element: Comparable {
	mutating func orderedInsert(_ item: Element) {
		var start = 0
		var end = self.count - 1
		
		guard start < end else {
			self.insert(item, at: 0)
			return
		}
		
		while start <= end {
			let mid = (start + end) / 2
			if self[mid] < item {
				start = mid + 1
			}
			else if item < self[mid] {
				end = mid - 1
			} else {
				self.insert(item, at: mid)
			}
		}
		self.insert(item, at: start)
	}
}
