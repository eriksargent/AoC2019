//
//  Puzzle2_2.swift
//  AOC18
//
//  Created by Erik Sargent on 12/2/18.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle2_2: Puzzle {
	static let day = 2
	static let puzzle = 2
	
	static func solve(input: String) -> String {
		
		let target = 19690720
		var noun = 0
		var verb = 0
		
		var opcodes: [Int] = []
		for code in input.components(separatedBy: ",") {
			if let opcode = Int(code) {
				opcodes.append(opcode)
			}
			else {
				opcodes.append(0)
			}
		}
		
		let originalOpcodes = opcodes
		
		while noun <= 99 {
			verb = 0
			while verb <= 99 {
				var pc = 0
				opcodes = originalOpcodes
				opcodes[1] = noun
				opcodes[2] = verb
				
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
						pc += 1
					}
				}
				
				if opcodes[0] == target {
					return String(100 * noun + verb)
				}
				else {
					verb += 1
				}
			}
			
			noun += 1
		}
		
		return "Not found"
	}
	
	enum Operation: Int {
		case nop = 0
		case add = 1
		case mult = 2
		case halt = 99
	}
}
