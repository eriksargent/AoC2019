//
//  Puzzle12_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/13/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle12_2: Puzzle {
	static let day = 12
	static let puzzle = 2

	static func solve(input: String) -> String {
		let moons = input.components(separatedBy: .newlines).compactMap({ Puzzle12_1.Moon(from: $0) })
		
		var pairs: [(Puzzle12_1.Moon, Puzzle12_1.Moon)] = []
		
		let numMoons = moons.count
		for (index, moon) in moons[0..<(numMoons - 1)].enumerated() {
			for otherMoon in moons[(index + 1)..<numMoons] {
				pairs.append((moon, otherMoon))
			}
		}
		
		let dimensions: [(WritableKeyPath<Point3D, Int>, WritableKeyPath<Vector3D, Int>)] = [
			(\.x, \.horizDistance),
			(\.y, \.vertDistance),
			(\.z, \.depthDistance)
		]
		
		var periods = [Int](repeating: 0, count: dimensions.count)
		
		DispatchQueue.concurrentPerform(iterations: dimensions.count) { index in
			let (pointPath, vectorPath) = dimensions[index]

			let startingPoints = moons.map({ $0.location[keyPath: pointPath] })
			let startingVelocities = moons.map({ $0.velocity[keyPath: vectorPath] })
			let startingMoons = Array(zip(startingPoints, startingVelocities))
			var count = 0
			
			var moonPoints = startingMoons
			
			while true {
				for index in  0..<(numMoons - 1) {
					for otherIndex in (index + 1)..<numMoons {
						let moon = moonPoints[index]
						let otherMoon = moonPoints[otherIndex]
						let diff = (moon.0 - otherMoon.0).limitTo(range: -1...1)
						moonPoints[index].1 = moon.1 - diff
						moonPoints[otherIndex].1 = otherMoon.1 + diff
					}
				}

				for (index, moon) in moonPoints.enumerated() {
					moonPoints[index].0 = moon.0 + moon.1
				}
				
				count += 1

				let startedOver = !zip(startingMoons, moonPoints).contains(where: { (start, current) -> Bool in
					let (startPoint, startVelocity) = start
					let (currentPoint, currentVelocity) = current
					return startPoint != currentPoint || startVelocity != currentVelocity
				})
				
				if startedOver {
					periods[index] = count
					return
				}
			}
		}
			
		let totalPeriod = periods.reduce(1, { $0.lcm(with: $1) })
		return String(totalPeriod)
	}
}
