//
//  Line.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


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
