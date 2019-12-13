//
//  Puzzle10.swift
//  AOC19Tests
//
//  Created by Erik Sargent on 12/9/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import XCTest

@testable import AOC19


class Puzzle10: PuzzleTestCase {
	override var day: Int { 10 }
	
	override func testPuzzle1(puzzle: Puzzle.Type) {
		assertSolution(for: ".#..# ..... ##### ....# ...##", returns: "8")
		assertSolution(for: "......#.#. #..#.#.... ..#######. .#.#.###.. .#..#..... ..#....#.# #..#....#. .##.#..### ##...#..#. .#....####", returns: "33")
		assertSolution(for: "#.#...#.#. .###....#. .#....#... ##.#.#.#.# ....#.#.#. .##..###.# ..#...##.. ..##....## ......#... .####.###.", returns: "35")
		assertSolution(for: ".#..#..### ####.###.# ....###.#. ..###.##.# ##.##.#.#. ....###..# ..#.#..#.# #..#.#.### .##...##.# .....#.#..", returns: "41")
		assertSolution(for: ".#..##.###...####### ##.############..##. .#.######.########.# .###.#######.####.#. #####.##.#.##.###.## ..#####..#.######### #################### #.####....###.#.#.## ##.################# #####.##.###..####.. ..######..##.####### ####.##.####...##..# .#####..#.######.### ##...#.##########... #.##########.####### .####.#.###.###.#.## ....##.##.###..##### .#.#.###########.### #.#.#.#####.####.### ###.##.####.##.#..##", returns: "210")
	}
	
	override func testPuzzle2(puzzle: Puzzle.Type) {
		assertSolution(for: ".#..##.###...####### ##.############..##. .#.######.########.# .###.#######.####.#. #####.##.#.##.###.## ..#####..#.######### #################### #.####....###.#.#.## ##.################# #####.##.###..####.. ..######..##.####### ####.##.####...##..# .#####..#.######.### ##...#.##########... #.##########.####### .####.#.###.###.#.## ....##.##.###..##### .#.#.###########.### #.#.#.#####.####.### ###.##.####.##.#..##", returns: "802")
	}
	
	func testAngle() {
		XCTAssertEqual(Vector(horizontalDistance: 0, verticalDistance: -1).getDegrees, 0)
		XCTAssertEqual(Vector(horizontalDistance: 1, verticalDistance: -1).getDegrees, 45)
		XCTAssertEqual(Vector(horizontalDistance: 1, verticalDistance: 0).getDegrees, 90)
		XCTAssertEqual(Vector(horizontalDistance: 1, verticalDistance: 1).getDegrees, 135)
		XCTAssertEqual(Vector(horizontalDistance: -1, verticalDistance: 0).getDegrees, 270)
	}
}
