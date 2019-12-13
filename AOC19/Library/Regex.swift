//
//  Regex.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


extension String {
	func firstMatch(of regex: String) -> String? {
		do {
			let expression = try NSRegularExpression(pattern: regex, options: [])
			guard let firstMatch = expression.firstMatch(in: self, options: [], range: NSRange(self.startIndex..<self.endIndex, in: self)) else { return nil }
			
			var matchRange = firstMatch.range
			if firstMatch.numberOfRanges >= 2 {
				let secondRange = firstMatch.range(at: 1)
				
				// Second range is a subset of the first one. This means there was likely a capture group, and that's what should be returned instead. The first result will always be the entire match
				if matchRange.union(secondRange) == matchRange && matchRange.intersection(secondRange) == secondRange {
					matchRange = secondRange
				}
			}
			
			if let targetRange = Range<String.Index>(matchRange, in: self) {
				return String(self[targetRange])
			}
			else {
				return nil
			}
		}
		catch {
			return nil
		}
	}
}
