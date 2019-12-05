//
//  Puzzle4_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/4/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle4_1: Puzzle {
	static let day = 4
	static let puzzle = 1

	static func solve(input: String) -> String {
		let range = parseRange(input: input)
		return String(PasswordCounter(from: range.lowerBound, end: range.upperBound)?.countPossibilities() ?? 0)
	}
	
	static func parseRange(input: String) -> ClosedRange<Int> {
		let comps = input.components(separatedBy: "-").compactMap { Int($0) }
		guard comps.count == 2 else { return 0...0 }
		return comps[0]...comps[1]
	}
	
	struct PasswordCounter {
		var start: [Int]
		var end: [Int]
		
		init?(from start: Int, end: Int) {
			self.start = String(start).compactMap({ Int(String($0)) })
			self.end = String(end).compactMap({ Int(String($0)) })
			
			guard self.start.count == 6, self.end.count == 6 else { return nil }
		}
		
		func countPossibilities() -> Int {
			let d0Start = start[0]
			let d0End = end[0]
			return countD0(from: d0Start, to: d0End)
		}
		
		func countD0(from: Int, to: Int) -> Int {
			let d1Start = max(start[1], from)
			let d1End = end[1]
			
			if from == to {
				return countNextDigit(level: 1, from: max(from, d1Start), to: d1End, previous: from, hasDoubled: false, firstRound: true, lastRound: true)
			}
			else if from < to {
				
				let firstCount = to - from + 1
				var counts = [Int](repeating: 0, count: firstCount)
				
				DispatchQueue.concurrentPerform(iterations: firstCount) { index in
					let digit = index + from
					var nextStart = digit
					if digit == from {
						nextStart = max(from, d1Start)
					}
					var nextEnd = 9
					if digit == to {
						nextEnd = d1End
					}
					counts[index] = countNextDigit(level: 1, from: nextStart, to: nextEnd, previous: digit, hasDoubled: false, firstRound: digit == from, lastRound: digit == to)
				}
				
				return counts.reduce(0, +)
			}
			
			return 0
		}
		
		func countNextDigit(level: Int, from: Int, to: Int, previous: Int, hasDoubled: Bool, firstRound: Bool = false, lastRound: Bool = false) -> Int {
			guard level < 5 else {
				if hasDoubled {
					return to - from + 1
				}
				else if from <= previous && previous <= to {
					return 1
				}
				return 0
			}
			
			let nextDigitStart = firstRound ? max(start[level + 1], from) : from
			let nextDigitEnd = lastRound ? end[level + 1] : 9
			let nextLevel = level + 1
			
			if from == to {
				return countNextDigit(level: nextLevel, from: nextDigitStart, to: nextDigitEnd, previous: from, hasDoubled: hasDoubled || previous == from, firstRound: firstRound, lastRound: lastRound)
			}
			else if from < to {
				var count = 0
				
				for digit in from...to {
					var nextStart = digit
					if digit == from {
						nextStart = max(from, nextDigitStart)
					}
					var nextEnd = 9
					if digit == to {
						nextEnd = nextDigitEnd
					}
					
					let nextDoubled = hasDoubled || previous == digit
					let nextFirstRound = firstRound && digit == from
					let nextLastRound = lastRound && digit == to
					
					count += countNextDigit(level: nextLevel, from: nextStart, to: nextEnd, previous: digit, hasDoubled: nextDoubled, firstRound: nextFirstRound, lastRound: nextLastRound)
				}
				
				return count
			}
			
			return 0
		}
	}
}
