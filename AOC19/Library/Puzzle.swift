//
//  Puzzle.swift
//  AOC18
//
//  Created by Erik Sargent on 11/26/18.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation


fileprivate let backgroundQueue = DispatchQueue(label: "BackgroundProcessing", qos: .userInitiated, attributes: .concurrent)


protocol Puzzle {
	static var name: String { get }
	static var day: Int { get }
	static var puzzle: Int { get }
	static func solve(input: String) -> String
}


extension Puzzle {
	static var name: String {
		return "Day \(day) - Puzzle \(puzzle)"
	}
	
	typealias TimedSolution = (output: String, runTime: TimeInterval)
	
	static func timeAndSolve(input: String, completion: @escaping (TimedSolution) -> ()) {
		backgroundQueue.async {
			let start = Date()
			let result = solve(input: input)
			let end = Date()
			let time = end.timeIntervalSince(start)
			
			DispatchQueue.main.async {
				completion((output: result, runTime: time))
			}
		}
	}
}


struct Puzzles {
	static let puzzles: [Puzzle.Type] = [
		Puzzle1_1.self,
		Puzzle1_2.self,
		Puzzle2_1.self,
		Puzzle2_2.self,
		Puzzle3_1.self,
		Puzzle3_2.self,
		Puzzle4_1.self,
		Puzzle4_2.self,
		Puzzle5_1.self,
		Puzzle5_2.self
	]
}


// MARK: - Template
/*
enum Puzzle<#day#>_<#puzzle#>: Puzzle {
	static let day = <#day#>
	static let puzzle = <#puzzle#>

	static func solve(input: String) -> String {
		return ""
	}
}
*/
