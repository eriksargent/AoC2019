//
//  Puzzle1_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/2/2019.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle1_1: Puzzle {
	static let day = 1
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		let masses = parseMasses(from: input)
		let totalFuel = getTotalFuelRequirement(from: masses)
		return String(totalFuel)
	}
	
	
	static func getFuelRequirement(from mass: Int) -> Int {
		return max(((mass / 3) - 2), 0)
	}

	static func getTotalFuelRequirement(from masses: [Int]) -> Int {
		return masses.map({ getFuelRequirement(from: $0) }).reduce(0, +)
	}

	static func parseMasses(from string: String) -> [Int] {
		let masses = string.components(separatedBy: .whitespacesAndNewlines)
		return masses.compactMap({ Int($0) })
	}
}
