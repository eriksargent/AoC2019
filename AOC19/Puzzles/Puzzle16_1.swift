//
//  Puzzle16_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/17/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle16_1: Puzzle {
	static let day = 16
	static let puzzle = 1
	
	static let basePattern = [0, 1, 0, -1]

	static func solve(input: String) -> String {
		let inputLength = input.count
		
		var data = input.compactMap({ Int(String($0)) })
		var nextData = data
		for _ in 0..<100 {
			
			for patternSize in 0..<inputLength {
				var patternIndex = patternSize
				var digitValue = 0
				
				while patternIndex < inputLength {
					let pattern = basePattern[((patternIndex + 1) / (patternSize + 1)) % 4]
					digitValue += data[patternIndex] * pattern
					
					if pattern == 0 {
						// Skip zeros
						patternIndex += patternSize + 1
					}
					else {
						patternIndex += 1
					}
				}
				
				nextData[patternSize] = abs(digitValue % 10)
			}
			
			data = nextData
		}
		
		return data[0..<8].map({ String($0) }).joined()
	}
}
