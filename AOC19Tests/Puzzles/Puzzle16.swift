//
//  Puzzle16.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/17/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle16: PuzzleTestCase {
	override var day: Int { 16 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: "80871224585914546619083218645595", returns: "24176176")
		assertSolution(for: "19617804207202209144916044189917", returns: "73745418")
		assertSolution(for: "69317163492948606335995924319873", returns: "52432133")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: "03036732577212944063491565474664", returns: "84462026")
		assertSolution(for: "02935109699940807407585447034323", returns: "78725270")
		assertSolution(for: "03081770884921959731165446850517", returns: "53553731")
	}
}
