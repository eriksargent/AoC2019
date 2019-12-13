//
//  Point.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


struct Point: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
	var x: Int
	var y: Int
	
	static let zero = Point(x: 0, y: 0)
	
	func line(to vector: CardinalVector) -> Line {
		let end = self + vector
		return Line(start: self, end: end)
	}
	
	func distance(to: Point) -> Int {
		return abs(x - to.x) + abs(y - to.y)
	}
	
	static func == (lhs: Point, rhs: Point) -> Bool {
		return lhs.x == rhs.x && lhs.y == rhs.y
	}
	
	var description: String {
		return "(\(x), \(y))"
	}
	
	var debugDescription: String {
		return description
	}
}


struct Point3D: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
	var x: Int
	var y: Int
	var z: Int
	
	static let zero = Point3D(x: 0, y: 0, z: 0)
	
	func distance(to: Point3D) -> Int {
		return abs(x - to.x) + abs(y - to.y) + abs(z - to.z)
	}
	
	static func == (lhs: Point3D, rhs: Point3D) -> Bool {
		return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
	}
	
	var description: String {
		return "(\(x), \(y), \(z))"
	}
	
	var debugDescription: String {
		return description
	}
}
