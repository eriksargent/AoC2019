//
//  Puzzle10_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/9/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle10_1: Puzzle {
	static let day = 10
	static let puzzle = 1

	static func solve(input: String) -> String {
		let grid = Grid(from: input)
		let best = grid.getBest()
		return String(best?.numSightLines ?? 0)
	}
	
	class Grid: CustomStringConvertible {
		var width: Int
		var height: Int
		var rows: [GridRow]
		private var allAsteroids: [Asteroid]
		
		class Asteroid: CustomStringConvertible, Equatable {
			var location: Point
			var numSightLines: Int
			
			init(at point: Point) {
				location = point
				numSightLines = 0
			}
			
			func distance(to other: Asteroid) -> Int {
				return location.distance(to: other.location)
			}
			
			static func == (lhs: Asteroid, rhs: Asteroid) -> Bool {
				return lhs.location == rhs.location
			}
			
			var description: String {
				return String(describing: location)
			}
		}
		
		class GridRow {
			var row: Int
			var asteroids: [Asteroid?]
			
			init(row: Int, input: String) {
				self.row = row
				asteroids = []
				asteroids.reserveCapacity(input.count)
				
				for (index, character) in input.enumerated() {
					if character == "#" {
						asteroids.append(Asteroid(at: Point(x: index, y: row)))
					}
					else {
						asteroids.append(nil)
					}
				}
			}
		}
		
		init(from input: String) {
			let gridRows = input.components(separatedBy: .whitespacesAndNewlines)
			guard gridRows.count > 0 && gridRows[0] != "" else {
				width = 0
				height = 0
				rows = []
				allAsteroids = []
				return
			}
			
			width = gridRows[0].count
			height = gridRows.count
			rows = []
			rows.reserveCapacity(height)
			
			for (index, row) in gridRows.enumerated() {
				rows.append(GridRow(row: index, input: row))
			}
			
			allAsteroids = rows.flatMap({ $0.asteroids.unwrapped() })
		}
		
		func getBest() -> Asteroid? {
			var bestLines = 0
			var bestAsteroid: Asteroid?
			
			for asteroid in allAsteroids {
				var unitVectors = Set<Vector>()
				
				for (_, vector, _) in orderedAsteroids(around: asteroid) {
					unitVectors.insert(vector.unit)
				}
				
				asteroid.numSightLines = unitVectors.count
				if asteroid.numSightLines > bestLines {
					bestLines = asteroid.numSightLines
					bestAsteroid = asteroid
				}
			}
			
			return bestAsteroid
		}
		
		func orderedAsteroids(around: Asteroid) -> [(Asteroid, Vector, Int)] {
			let astroidDistances = allAsteroids.compactMap({ asteroid -> (Asteroid, Vector, Int)? in
				if asteroid == around {
					return nil
				}
				
				let vector = Vector(from: around.location, to: asteroid.location)
				return (asteroid, vector, vector.length)
			})
			let sorted = astroidDistances.sorted { lhs, rhs -> Bool in
				return lhs.2 < rhs.2
			}
			return sorted
		}
		
		subscript(x: Int, y: Int) -> Asteroid? {
			get {
				return rows[x].asteroids[y]
			}
			set {
				rows[x].asteroids[y] = newValue
			}
		}
		
		var description: String {
			var desc = ""
			for row in rows {
				for value in row.asteroids {
					if let asteroid = value {
						desc += String(asteroid.numSightLines)
					}
					else {
						desc += "."
					}
				}
				desc += "\n"
			}
			return desc
		}
	}
}
