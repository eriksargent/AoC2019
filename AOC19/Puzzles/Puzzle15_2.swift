//
//  Puzzle15_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/16/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle15_2: Puzzle {
	static let day = 15
	static let puzzle = 2
	
	static func solve(input: String) -> String {
		let comp = Puzzle11_2.IntCode(with: input)
		let width = 50
		let height = 50
		var maze = Puzzle15_1.Maze(width: width, height: height)
		var droid = Point(x: width / 2, y: height / 2)
		maze[droid] = .start
		var o2System: Point?
		
		// Generate complete map
		var nextDirection: Puzzle15_1.Compass = .north
		var finished = false
		while !comp.halted && !finished {
			let outputs = comp.process(input: [nextDirection.rawValue])
			guard !outputs.isEmpty else { break }
			
			let nextPoint = droid.point(oneUnitToward: nextDirection.direction)
			let tile = Puzzle15_1.GridTile(rawValue: outputs[0]) ?? .unknown
			
			switch tile {
			case .wall:
				nextDirection = Puzzle15_1.Compass(from: nextDirection.direction.rotate90Right)
				maze[nextPoint] = tile
				
			case .hallway:
				if maze[nextPoint] == .start {
					finished = true
				}
				
				droid = nextPoint
				nextDirection = Puzzle15_1.Compass(from: nextDirection.direction.rotate90Left)
				maze[nextPoint] = tile
				
			case .O2System:
				droid = nextPoint
				o2System = droid
				nextDirection = Puzzle15_1.Compass(from: nextDirection.direction.rotate90Left)
				maze[nextPoint] = tile
				print("O2 System at \(droid)")
//				print(maze)
				
			case .unknown, .start:
				break
			}
			
//			print(maze)
		}
		
		guard let o2Loc = o2System else { return "" }
		
		var numHallwaySpaces = maze.grid.filter({ $0 == .hallway }).count
		var outerO2Spaces = Set([o2Loc])
		var minutes = 0
		while numHallwaySpaces > 0 {
			var nextO2Spaces = Set<Point>()
			
			for point in outerO2Spaces {
				let directions = [Compass.north, Compass.east, Compass.south, Compass.west]
				let points = directions.map({ point.point(oneUnitToward: $0.direction) })
				let hallways = points.filter({ maze[$0] == .hallway })
				
				nextO2Spaces.formUnion(hallways)
			}

			for hallway in nextO2Spaces {
				maze[hallway] = .O2System
			}
			
			minutes += 1
			
			outerO2Spaces = nextO2Spaces
			numHallwaySpaces -= nextO2Spaces.count
		}
		
//		print(maze)
//		print(minutes)
		
		return String(minutes)
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
