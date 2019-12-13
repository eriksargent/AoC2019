//
//  Puzzle12.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/13/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle12: PuzzleTestCase {
	override var day: Int { 12 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>;10", returns: "179")
		assertSolution(for: "<x=-8, y=-10, z=0>\n<x=5, y=5, z=10>\n<x=2, y=-7, z=3>\n<x=9, y=-8, z=-3>;100", returns: "1940")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>", returns: "2772")
		assertSolution(for: "<x=-8, y=-10, z=0>\n<x=5, y=5, z=10>\n<x=2, y=-7, z=3>\n<x=9, y=-8, z=-3>", returns: "4686774924")
	}
}
