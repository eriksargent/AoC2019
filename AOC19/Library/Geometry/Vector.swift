//
//  Vector.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Direction: String, CustomStringConvertible, CustomDebugStringConvertible {
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
	
	var debugDescription: String {
		return description
	}
	
	var rotate90Right: Direction {
		switch self {
		case .up:
			return .right
		case .right:
			return .down
		case .down:
			return .left
		case .left:
			return .up
		}
	}
	
	var rotate90Left: Direction {
		switch self {
		case .up:
			return .left
		case .right:
			return .up
		case .down:
			return .right
		case .left:
			return .down
		}
	}
}


struct CardinalVector: CustomStringConvertible, Equatable {
	var direction: Direction
	var distance: Int
	
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
	
	static func + (lhs: Point, rhs: CardinalVector) -> Point {
		return rhs.add(to: lhs)
	}
	
	static func == (lhs: CardinalVector, rhs: CardinalVector) -> Bool {
		return lhs.direction == rhs.direction && lhs.distance == rhs.distance
	}
}


struct Vector: CustomStringConvertible, Equatable, Hashable {
	var horizDistance: Int
	var vertDistance: Int
	
	init(horizontalDistance: Int, verticalDistance: Int) {
		horizDistance = horizontalDistance
		vertDistance = verticalDistance
	}
	
	init(from: Point, to: Point) {
		horizDistance = to.x - from.x
		vertDistance = to.y - from.y
	}
	
	var length: Int {
		return abs(horizDistance) + abs(vertDistance)
	}
	
	/// Gets the degrees for the ange (Note: 0 degrees is -y (0,-1) to make puzzle 10_2 easier, and goes clockwise
	var getDegrees: Double {
		let x = Double(horizDistance)
		let y = Double(vertDistance)

		var angle = atan2(-y, -x) * 180 / .pi + 270
		if angle >= 360 {
			angle -= 360
		}
		
		return angle
	}
	
	var unit: Vector {
		let gcd = abs(horizDistance.gcd(with: vertDistance))
		return Vector(horizontalDistance: horizDistance / gcd, verticalDistance: vertDistance / gcd)
	}
	
	var description: String {
		return "(\(horizDistance), \(vertDistance))"
	}
	
	func add(to point: Point) -> Point {
		return Point(x: point.x + horizDistance, y: point.y + vertDistance)
	}
	
	static func + (lhs: Point, rhs: Vector) -> Point {
		return rhs.add(to: lhs)
	}
	
	static func == (lhs: Vector, rhs: Vector) -> Bool {
		return lhs.horizDistance == rhs.horizDistance && lhs.vertDistance == rhs.vertDistance
	}
}


struct Vector3D: CustomStringConvertible, Equatable, Hashable {
	var horizDistance: Int
	var vertDistance: Int
	var depthDistance: Int
	
	init(horizontalDistance: Int, verticalDistance: Int, depthDistance: Int) {
		self.horizDistance = horizontalDistance
		self.vertDistance = verticalDistance
		self.depthDistance = depthDistance
	}
	
	init(from: Point3D, to: Point3D) {
		horizDistance = to.x - from.x
		vertDistance = to.y - from.y
		depthDistance = to.z - from.z
	}
	
	var length: Int {
		return abs(horizDistance) + abs(vertDistance) + abs(depthDistance)
	}
	
	var description: String {
		return "(\(horizDistance), \(vertDistance), \(depthDistance))"
	}
	
	func add(to point: Point3D) -> Point3D {
		return Point3D(x: point.x + horizDistance, y: point.y + vertDistance, z: point.z + depthDistance)
	}
	
	static func + (lhs: Point3D, rhs: Vector3D) -> Point3D {
		return rhs.add(to: lhs)
	}
	
	static func == (lhs: Vector3D, rhs: Vector3D) -> Bool {
		return lhs.horizDistance == rhs.horizDistance && lhs.vertDistance == rhs.vertDistance && lhs.depthDistance == rhs.depthDistance
	}
}
