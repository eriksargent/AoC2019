//
//  Puzzle3_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle3_2: Puzzle {
	static let day = 3
	static let puzzle = 2

	static func solve(input: String) -> String {
		let (firstLines, secondLines) = Puzzle3_1.getLines(from: input)
		
		var distances: [Int] = []
		for (firstIndex, first) in firstLines.dropFirst().enumerated() {
			for (secondIndex, second) in secondLines.enumerated() {
				if let intersection = first.intersection(with: second) {
					
					var distance = 0
					for segment in firstLines[0...firstIndex] {
						distance += segment.length()
					}
					distance += first.start.distance(to: intersection)
					for segment in secondLines[0..<secondIndex] {
						distance += segment.length()
					}
					distance += second.start.distance(to: intersection)
					
					distances.append(distance)
				}
			}
		}
		
		return "\(distances.min() ?? 0)"
	}
}
