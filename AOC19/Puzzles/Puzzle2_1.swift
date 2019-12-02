//
//  Puzzle2_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/3/18.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle2_1: Puzzle {
	static let day = 2
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		var opcodes: [Int] = []
		for code in input.components(separatedBy: ",") {
			if let opcode = Int(code) {
				opcodes.append(opcode)
			}
			else {
				opcodes.append(0)
			}
		}
		
		var pc = 0
		while opcodes[pc] != Operation.halt.rawValue {
			if let operation = Operation(rawValue: opcodes[pc]) {
				switch operation {
				case .nop:
					pc += 1
					
				case .add:
					opcodes[opcodes[pc + 3]] = opcodes[opcodes[pc + 1]] + opcodes[opcodes[pc + 2]]
					pc += 4
					
				case .mult:
					opcodes[opcodes[pc + 3]] = opcodes[opcodes[pc + 1]] * opcodes[opcodes[pc + 2]]
					pc += 4
					
				case .halt:
					break
				}
			}
			else {
				return "Unknown opcode \(opcodes[pc]) at index \(pc)"
			}
		}
		
		return opcodes.map({ String($0) }).joined(separator: ",")
	}
	
	enum Operation: Int {
		case nop = 0
		case add = 1
		case mult = 2
		case halt = 99
	}
}
