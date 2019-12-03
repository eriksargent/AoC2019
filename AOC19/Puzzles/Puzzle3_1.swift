//
//  Puzzle3_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics


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
		
		do {
			var firstLines: [Line] = []
			var secondLines: [Line] = []
			
			for wire in wires {
				var start = Point(x: 0, y: 0)
				var lines: [Line] = []
				let moves = try wire.components(separatedBy: ",").map({ try Move($0) })
				for move in moves {
					let line = start.line(to: move)
					lines.append(line)
					start = line.end
				}
				
				if firstLines.isEmpty {
					firstLines = lines
				}
				else {
					secondLines = lines
				}
			}
			
			return (firstLines, secondLines)
		}
		catch let error {
			print("Unable to parse input")
			print(error)
			return ([], [])
		}
	}
	
	struct Point {
		var x: Int
		var y: Int
		
		static let zero = Point(x: 0, y: 0)
		
		func line(to move: Move) -> Line {
			let end = self + move
			return Line(start: self, end: end)
		}
		
		func distance(to: Point) -> Int {
			return abs(x - to.x) + abs(y - to.y)
		}
	}
	
	struct Line {
		var start: Point
		var end: Point
		
		func intersection(with other: Line) -> Point? {
			let distance = Double((end.x - start.x) * (other.end.y - other.start.y) - (end.y - start.y) * (other.end.x - other.start.x))
			// Parallel
			if distance == 0 {
				return nil
			}

			let u = Double((other.start.x - start.x) * (other.end.y - other.start.y) - (other.start.y - start.y) * (other.end.x - other.start.x)) / distance
			let v = Double((other.start.x - start.x) * (end.y - start.y) - (other.start.y - start.y) * (end.x - start.x)) / distance

			// Intersection not inside self
			if (u < 0.0 || u > 1.0) {
				return nil
			}
			
			// Intersection not inside other
			if (v < 0.0 || v > 1.0) {
				return nil
			}

			return Point(x: start.x + Int(u * Double(end.x - start.x)), y: start.y + Int(u * Double(end.y - start.y)))
		}
		
		func length() -> Int {
			return start.distance(to: end)
		}
	}
	
	struct Move: CustomStringConvertible {
		enum Direction: String, CustomStringConvertible {
			case up = "U"
			case left = "L"
			case down = "D"
			case right = "R"
			
			var description: String {
				switch self {
				case .up: return "⬆"
				case .left: return "⬅"
				case .down: return "⬇"
				case .right: return "➡"
				}
			}
		}
		
		enum ParseError: Error {
			case invalidDirection
			case noDirection
			case noDistance
		}
		
		var direction: Direction
		var distance: Int
		
		init(_ string: String) throws {
			guard let dirString = string.firstMatch(of: "^[ULDR]") else {
				throw ParseError.noDirection
			}
			guard let dir = Direction(rawValue: dirString) else {
				throw ParseError.invalidDirection
			}
			guard let distString = string.firstMatch(of: "\\d+"), let dist = Int(distString) else {
				throw ParseError.noDistance
			}
			
			direction = dir
			distance = dist
		}
		
		var description: String {
			return "\(String(describing: direction))\(distance)"
		}
		
		func add(to point: Point) -> Point {
			switch direction {
			case .up: return Point(x: point.x, y: point.y + distance)
			case .left: return Point(x: point.x - distance, y: point.y)
			case .down: return Point(x: point.x, y: point.y - distance)
			case .right: return Point(x: point.x + distance, y: point.y)
			}
		}
		
		static func + (lhs: Point, rhs: Move) -> Point {
			return rhs.add(to: lhs)
		}
	}
}

