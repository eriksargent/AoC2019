//
//  Puzzle5.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/5/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle5: PuzzleTestCase {
	override var day: Int { 5 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "3,0,4,0,99;1234", returns: "1234")
		assertSolution(for: "3,0,1,0,2,0,4,0,99;1234", returns: "1235")
		assertSolution(for: "3,0,2,0,2,0,4,0,99;4", returns: "8")
		assertSolution(for: "3,0,0001,0,2,0,4,0,99;1234", returns: "1235")
		assertSolution(for: "3,0,0002,0,2,0,4,0,99;4", returns: "8")
		assertSolution(for: "3,0,1001,0,2,0,4,0,99;1234", returns: "1236")
		assertSolution(for: "3,0,1002,0,3,0,4,0,99;4", returns: "12")
		assertSolution(for: "1002,6,3,6,4,6,33", returns: "99")
		assertSolution(for: "1101,100,-1,6,4,6,0", returns: "99")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "3,0,4,0,99;1234", returns: "1234")
		assertSolution(for: "3,0,1,0,2,0,4,0,99;1234", returns: "1235")
		assertSolution(for: "3,0,2,0,2,0,4,0,99;4", returns: "8")
		assertSolution(for: "3,0,0001,0,2,0,4,0,99;1234", returns: "1235")
		assertSolution(for: "3,0,0002,0,2,0,4,0,99;4", returns: "8")
		assertSolution(for: "3,0,1001,0,2,0,4,0,99;1234", returns: "1236")
		assertSolution(for: "3,0,1002,0,3,0,4,0,99;4", returns: "12")
		assertSolution(for: "1002,6,3,6,4,6,33", returns: "99")
		assertSolution(for: "1101,100,-1,6,4,6,0", returns: "99")
		
		assertSolution(for: "3,9,8,9,10,9,4,9,99,-1,8;8", returns: "1")
		assertSolution(for: "3,9,8,9,10,9,4,9,99,-1,8;0", returns: "0")
		assertSolution(for: "3,9,7,9,10,9,4,9,99,-1,8;4", returns: "1")
		assertSolution(for: "3,9,7,9,10,9,4,9,99,-1,8;9", returns: "0")
		assertSolution(for: "3,3,1108,-1,8,3,4,3,99;8", returns: "1")
		assertSolution(for: "3,3,1108,-1,8,3,4,3,99;0", returns: "0")
		assertSolution(for: "3,3,1107,-1,8,3,4,3,99;4", returns: "1")
		assertSolution(for: "3,3,1107,-1,8,3,4,3,99;9", returns: "0")
		
		assertSolution(for: "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9;0", returns: "0")
		assertSolution(for: "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9;12", returns: "1")
		assertSolution(for: "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9;-12", returns: "1")
		
		assertSolution(for: "3,3,1105,-1,9,1101,0,0,12,4,12,99,1;0", returns: "0")
		assertSolution(for: "3,3,1105,-1,9,1101,0,0,12,4,12,99,1;12", returns: "1")
		assertSolution(for: "3,3,1105,-1,9,1101,0,0,12,4,12,99,1;-12", returns: "1")
		
		assertSolution(for: "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99;7", returns: "999")
		assertSolution(for: "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99;8", returns: "1000")
		assertSolution(for: "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99;12", returns: "1001")
	}
}
