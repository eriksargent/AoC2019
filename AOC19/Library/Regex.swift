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
			let firstMatch = expression.firstMatch(in: self, options: [], range: NSRange(self.startIndex..<self.endIndex, in: self))
			if let matchRange = firstMatch?.range, let targetRange = Range<String.Index>(matchRange, in: self) {
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
