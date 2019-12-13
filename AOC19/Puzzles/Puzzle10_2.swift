//
//  Puzzle10_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/9/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle10_2: Puzzle {
	static let day = 10
	static let puzzle = 2

	static func solve(input: String) -> String {
		let grid = Puzzle10_1.Grid(from: input)
		guard let best = grid.getBest() else { return "" }
		
		let vaporizationOrder = grid.getVaporizationOrder(from: best)
		guard vaporizationOrder.count >= 200 else { return "" }
		
		let target = vaporizationOrder[199]
		let x = target.location.x
		let y = target.location.y
		
		return String(x * 100 + y)
	}
}


extension Puzzle10_1.Grid {
	func getVaporizationOrder(from base: Asteroid) -> [Puzzle10_1.Grid.Asteroid] {
		var asteroidDirections: [Vector: [(Asteroid, Vector, Int)]] = [:]
		
		for (asteroid, vector, length) in orderedAsteroids(around: base) {
			let unit = vector.unit
//			let angle = vector.getDegrees
			if var group = asteroidDirections[unit] {
				group.append((asteroid, vector, length))
				group.sort(by: { $0.2 < $1.2 })
				asteroidDirections[unit] = group
			}
			else {
				asteroidDirections[unit] = [(asteroid, vector, length)]
			}
		}
		
		var zapOrder: [Asteroid] = []
		
		while !asteroidDirections.isEmpty {
			let keys = asteroidDirections.keys.sorted(by: { lhs, rhs in lhs.getDegrees < rhs.getDegrees })
			for angle in keys {
				guard var asteroids = asteroidDirections[angle] else {
					continue
				}
				
				let asteroid = asteroids.removeFirst().0
				zapOrder.append(asteroid)
				
				if asteroids.isEmpty {
					asteroidDirections[angle] = nil
				}
				else {
					asteroidDirections[angle] = asteroids
				}
			}
		}
		
		return zapOrder
	}
}
