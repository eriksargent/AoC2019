//
//  Puzzle9.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/9/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle9: PuzzleTestCase {
	override var day: Int { 9 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99", returns: "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
		XCTAssertEqual(Puzzle9_1.solve(input: "1102,34915192,34915192,7,4,7,99,0").count, 16)
		assertSolution(for: "104,1125899906842624,99", returns: "1125899906842624")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
//		assertSolution(for: <#input#>, returns: <#output#>)
	}
}
