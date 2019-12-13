//
//  Puzzle12_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/13/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle12_1: Puzzle {
	static let day = 12
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		let comps = input.components(separatedBy: ";")
		guard comps.count == 2, let iterations = Int(comps[1]) else { return "" }
		
		let moons = comps[0].components(separatedBy: .newlines).compactMap({ Moon(from: $0) })
		
		var pairs: [(Moon, Moon)] = []
		
		let numMoons = moons.count
		for (index, moon) in moons[0..<(numMoons - 1)].enumerated() {
			for otherMoon in moons[(index + 1)..<numMoons] {
				pairs.append((moon, otherMoon))
			}
		}
		
		for _ in 0..<iterations {
			for (moon, otherMoon) in pairs {
				moon.applyGravity(with: otherMoon)
			}
			
			for moon in moons {
				moon.applyVelocity()
			}
		}
		
		return String(moons.map({ $0.totalEnergy}).sum())
	}
	
	
	class Moon: Equatable, Hashable, CustomStringConvertible {
		var location: Point3D
		var velocity = Vector3D(horizontalDistance: 0, verticalDistance: 0, depthDistance: 0)
		
		init?(from description: String) {
			if let xString = description.firstMatch(of: "x=([-]?\\d+)"), let x = Int(xString),
				let yString = description.firstMatch(of: "y=([-]?\\d+)"), let y = Int(yString),
				let zString = description.firstMatch(of: "z=([-]?\\d+)"), let z = Int(zString) {
				
				self.location = Point3D(x: x, y: y, z: z)
			}
			else {
				return nil
			}
		}
		
		init(copying: Moon) {
			location = copying.location
			velocity = copying.velocity
		}
		
		func applyGravity(with other: Moon) {
			applyGravity(with: other, pointDimension: \.x, lengthDimension: \.horizDistance)
			applyGravity(with: other, pointDimension: \.y, lengthDimension: \.vertDistance)
			applyGravity(with: other, pointDimension: \.z, lengthDimension: \.depthDistance)
		}
		
		func applyGravity(with other: Moon, pointDimension: KeyPath<Point3D, Int>, lengthDimension: WritableKeyPath<Vector3D, Int>) {
			let diff = (location[keyPath: pointDimension] - other.location[keyPath: pointDimension]).limitTo(range: -1...1)
			velocity[keyPath: lengthDimension] -= diff
			other.velocity[keyPath: lengthDimension] += diff
		}
		
		func applyVelocity() {
			location = location + velocity
		}
		
		func applyVelocity(pointDimension: WritableKeyPath<Point3D, Int>, lengthDimension: KeyPath<Vector3D, Int>) {
			location[keyPath: pointDimension] = location[keyPath: pointDimension] + velocity[keyPath: lengthDimension]
		}
		
		var potentialEnergy: Int {
			return abs(location.x) + abs(location.y) + abs(location.z)
		}
		
		var kineticEnergy: Int {
			return abs(velocity.horizDistance) + abs(velocity.vertDistance) + abs(velocity.depthDistance)
		}
		
		var totalEnergy: Int {
			return potentialEnergy * kineticEnergy
		}
		
		var description: String {
			return "<pos=\(location), vel=\(velocity)>"
		}
		
		static func == (lhs: Moon, rhs: Moon) -> Bool {
			return lhs.location == rhs.location && lhs.velocity == rhs.velocity
		}
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(location)
			hasher.combine(velocity)
		}
	}
}
