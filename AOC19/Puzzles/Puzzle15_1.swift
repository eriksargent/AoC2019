//
//  Puzzle15_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/16/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle15_1: Puzzle {
	static let day = 15
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		
		let solver = Solver(input)
		
		guard let best = [Compass.north, Compass.east, Compass.south, Compass.west].compactMap({ direction -> Int? in
			var solver = Solver(from: solver)
			return solver.minPathLength(in: direction)
		}).sorted().first else { return "" }
		
		print(best)
		
		return String(best)
	}
	
	
	struct Solver {
		var comp: Puzzle11_2.IntCode
		var maze: Maze
		
		let width = 50
		let height = 50
		let start: Point
		var location: Point
		
		init(_ input: String) {
			comp = Puzzle11_2.IntCode(with: input)
			maze = Maze(width: width, height: height)
			start = Point(x: width / 2, y: height / 2)
			location = start
		}
		
		init(from: Solver) {
			comp = Puzzle11_2.IntCode(from: from.comp)
			maze = Maze(from: from.maze)
			start = Point(x: width / 2, y: height / 2)
			location = from.location
		}
		
		mutating func minPathLength(in direction: Compass) -> Int? {
			let outputs = comp.process(input: [direction.rawValue])
			guard !outputs.isEmpty else { return nil }
			
			let nextPoint = location.point(oneUnitToward: direction.direction)
			
			guard nextPoint != start else { return nil }
			
			let tile = GridTile(rawValue: outputs[0]) ?? .unknown
			
			switch tile {
			case .wall:
				return nil
				
			case .hallway:
				if maze[nextPoint] == .start {
					return nil
				}
				location = nextPoint
				maze[location] = tile
				
				let straight = direction.direction
				let right = straight.rotate90Right
				let left = straight.rotate90Left
				
				guard let best = [straight, right, left].map({ Compass(from: $0) }).compactMap({ direction -> Int? in
					var solver = Solver(from: self)
					return solver.minPathLength(in: direction)
				}).sorted().first else { return nil }
				
				return best + 1
				
			case .O2System:
				return 1
				
			case .unknown, .start:
				return nil
			}
		}
	}
	
	
	enum GridTile: Int {
		case wall = 0
		case hallway
		case O2System
		case unknown
		case start
		
		var stringValue: String {
			switch self {
			case .wall: return "#"
			case .hallway: return "."
			case .O2System: return "O"
			case .unknown: return " "
			case .start: return "S"
			}
		}
	}
	
	
	enum Compass: Int, CustomStringConvertible {
		case north = 1
		case south = 2
		case west = 3
		case east = 4
		
		var direction: Direction {
			switch self {
			case .north: return .up
			case .south: return .down
			case .west: return .left
			case .east: return .right
			}
		}
		
		init(from direction: Direction) {
			switch direction {
			case .up: self = .north
			case .down: self = .south
			case .left: self = .west
			case .right: self = .east
			}
		}
		
		var description: String {
			return direction.description
		}
	}
	
	
	struct Maze: CustomStringConvertible {
		var grid: [GridTile]
		var width: Int
		var height: Int
		
		init(width: Int, height: Int) {
			self.width = width
			self.height = height
			self.grid = [GridTile](repeating: .unknown, count: width * height)
		}
		
		init(from: Maze) {
			self.width = from.width
			self.height = from.height
			self.grid = from.grid
		}
		
		func copy() -> Maze {
			return Maze(from: self)
		}
		
		subscript(x: Int, y: Int) -> GridTile {
			get {
				return grid[x + y * width]
			}
			set {
				grid[x + y * width] = newValue
			}
		}
		
		subscript(point: Point) -> GridTile {
			get {
				return grid[point.x + point.y * width]
			}
			set {
				grid[point.x + point.y * width] = newValue
			}
		}
		
		var description: String {
			var rows = [String]()
			for y in 0..<height {
				var col = ""
				for x in 0..<width {
					col += self[x, y].stringValue
				}
				rows.append(col)
			}
			return rows.joined(separator: "\n")
		}
	}
}
