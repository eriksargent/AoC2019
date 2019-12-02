//
//  Puzzle1_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/2/2019.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle1_2: Puzzle {
	static let day = 1
	static let puzzle = 2
	
	static func solve(input: String) -> String {
		let masses = Puzzle1_1.parseMasses(from: input)
		let totalFuel = getTotalFuelRequirement(from: masses)
		return String(totalFuel)
	}
	

	private static func getCompleteFuelRequirement(from mass: Int) -> Int {
		var fuel = Puzzle1_1.getFuelRequirement(from: mass)
		var total = fuel
		while fuel > 0 {
			fuel = Puzzle1_1.getFuelRequirement(from: fuel)
			total += fuel
		}
		return total
	}

	private static func getTotalFuelRequirement(from masses: [Int]) -> Int {
		return masses.map({ getCompleteFuelRequirement(from: $0) }).reduce(0, +)
	}
}

