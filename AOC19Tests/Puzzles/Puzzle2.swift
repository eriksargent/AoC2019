//
//  Puzzle2.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/3/18.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle2: PuzzleTestCase {
	override var day: Int { 2 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "1,0,0,3,99", returns: "1,0,0,2,99")
		assertSolution(for: "1,0,0,0,99", returns: "2,0,0,0,99")
		assertSolution(for: "2,3,0,3,99", returns: "2,3,0,6,99")
		assertSolution(for: "2,4,4,5,99,0", returns: "2,4,4,5,99,9801")
		assertSolution(for: "1,1,1,4,99,5,6,0,99", returns: "30,1,1,4,2,5,6,0,99")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		
	}
}
