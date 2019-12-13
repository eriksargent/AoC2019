//
//  Puzzle3_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle3_1: Puzzle {
	static let day = 3
	static let puzzle = 1

	static func solve(input: String) -> String {
		let (firstLines, secondLines) = getLines(from: input)
		
		var distances: [Int] = []
		for first in firstLines.dropFirst() {
			for second in secondLines {
				if let intersection = first.intersection(with: second) {
					distances.append(intersection.distance(to: .zero))
				}
			}
		}
		
		return "\(distances.min() ?? 0)"
	}
	
	static func getLines(from input: String) -> ([Line], [Line]) {
		let wires = input.components(separatedBy: .newlines)
		guard wires.count == 2 else { return ([], []) }
		
		var firstLines: [Line] = []
		var secondLines: [Line] = []

		DispatchQueue.concurrentPerform(iterations: 2) { iteration in
			do {
				let wire = wires[iteration]
				var start = Point(x: 0, y: 0)
				let vectorComponents = wire.components(separatedBy: ",")
				var lines: [Line] = []
				
				for comp in vectorComponents {
					let vector = try CardinalVector(comp)
					let line = start.line(to: vector)
					lines.append(line)
					start = line.end
				}
				
				if iteration == 0 {
					firstLines = lines
				}
				else {
					secondLines = lines
				}
			}
			catch _ {}
		}
		
		return (firstLines, secondLines)
	}
}


enum ParseError: Error {
	case invalidDirection
	case noDirection
	case noDistance
}


private extension CardinalVector {
	init(_ string: String) throws {
		guard let dirString = string.first else {
			throw ParseError.noDirection
		}
		guard let dir = Direction(rawValue: String(dirString)) else {
			throw ParseError.invalidDirection
		}
		let distString = string.dropFirst()
		guard let dist = Int(distString) else {
			throw ParseError.noDistance
		}
		
		direction = dir
		distance = dist
	}
}

