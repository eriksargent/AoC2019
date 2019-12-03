//
//  Point.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


struct Point {
	var x: Int
	var y: Int
	
	static let zero = Point(x: 0, y: 0)
	
	func line(to vector: Vector) -> Line {
		let end = self + vector
		return Line(start: self, end: end)
	}
	
	func distance(to: Point) -> Int {
		return abs(x - to.x) + abs(y - to.y)
	}
}
