//
//  Puzzle7_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/7/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle7_1: Puzzle {
	static let day = 7
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		var possibilities = [Int](repeating: 0, count: 5)
		
		DispatchQueue.concurrentPerform(iterations: 5) { order in
			possibilities[order] = findBestSequence(phase: 1, sequence: "\(order)", instructions: input)
		}
		
		return String(possibilities.max() ?? 0)
	}
	
	static func findBestSequence(phase: Int, sequence: String, instructions: String) -> Int {
		var best = 0
		for order in 0..<5 {
			guard !sequence.contains(String(order)) else {
				continue
			}
			
			let nextSequence = "\(sequence),\(order)"
			
			if phase == 4 {
				let result = testInput(instructions: instructions, sequence: nextSequence)
				best = max(best, result)
			}
			else {
				let result = findBestSequence(phase: phase + 1, sequence: nextSequence, instructions: instructions)
				best = max(best, result)
			}
		}
		
		return best
	}
	
	static func testInput(instructions: String, sequence: String) -> Int {
		let phases = sequence.components(separatedBy: ",")
		guard phases.count == 5 else { return 0 }
		
		var outputPower = "0"
		for phase in phases {
			let phaseInput = "\(instructions);\(phase),\(outputPower)"
			outputPower = Puzzle5_2.solve(input: phaseInput)
		}
		
		return Int(outputPower) ?? 0
	}
}
