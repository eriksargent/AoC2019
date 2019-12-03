//
//  Vector.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Direction: String, CustomStringConvertible {
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
}


struct Vector: CustomStringConvertible {
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
	
	static func + (lhs: Point, rhs: Vector) -> Point {
		return rhs.add(to: lhs)
	}
}
