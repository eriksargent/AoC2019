//
//  Puzzle9_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/9/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle9_1: Puzzle {
	static let day = 9
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		// Split program and inputs by a semicolon
		let arguments = input.components(separatedBy: ";")
		guard arguments.count >= 1 else { return "" }
		
		let inputs = arguments[1].components(separatedBy: ",").compactMap({ Int($0) })
		
		let computer = IntCode(with: arguments[0])
		
		return computer.process(input: inputs)
	}
	
	class IntCode {
		let instructions: String
		private var opcodes: [Int] = []
		private var pc = 0
		private var relativeBase = 0
		
		init(with instructions: String) {
			self.instructions = instructions
			
			self.reset()
		}
		
		init(from: IntCode) {
			self.instructions = from.instructions
			self.opcodes = from.opcodes
			self.pc = from.pc
		}
		
		func verifyIndex(at position: Int) {
			if position >= opcodes.count {
				let current = opcodes.count
				opcodes.append(contentsOf: [Int](repeating: 0, count: max(current, position - current + 1)))
			}
		}
		
		func value(at position: Int, mode: Mode) -> Int {
			verifyIndex(at: position)
			let pos = opcodes[position]
			
			switch mode {
			case .position:
				verifyIndex(at: pos)
				return opcodes[pos]
			case .immediate:
				return pos
			case .relative:
				let relative = relativeBase + opcodes[position]
				verifyIndex(at: relative)
				return opcodes[relative]
			}
		}
		
		func write(_ value: Int, to position: Int, mode: Mode) {
			verifyIndex(at: position)
			let pos = opcodes[position]
			
			switch mode {
			case .position:
				verifyIndex(at: pos)
				opcodes[pos] = value
			case .immediate:
				break
			case .relative:
				let relative = relativeBase + pos
				verifyIndex(at: relative)
				opcodes[relative] = value
			}
		}
		
		func reset() {
			opcodes = instructions.components(separatedBy: ",").map({ Int($0) ?? 0 })
			pc = 0
		}
		
		func copy() -> IntCode {
			return IntCode(from: self)
		}
		
		func process(input: [Int]) -> String {
			var inputs = input
			
			var outputs: [Int] = []
			
			while opcodes[pc] != Operation.halt.rawValue {
				let parameter = Parameter(from: opcodes[pc])
				
				switch parameter.op {
				case .nop:
					pc += 1
					
				case .add:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					let v2 = value(at: pc + 2, mode: parameter.modes[1])
					let result = v1 + v2
					write(result, to: pc + 3, mode: parameter.modes[2])
					pc += 4
					
				case .mult:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					let v2 = value(at: pc + 2, mode: parameter.modes[1])
					let result = v1 * v2
					write(result, to: pc + 3, mode: parameter.modes[2])
					pc += 4
					
				case .input:
					if !inputs.isEmpty {
						let input = inputs.remove(at: 0)
						write(input, to: pc + 1, mode: parameter.modes[0])
					}
					else {
						break
					}
					pc += 2
					
				case .output:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					outputs.append(v1)
					pc += 2
					
				case .jumpIfTrue:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					let v2 = value(at: pc + 2, mode: parameter.modes[1])
					if v1 != 0 {
						pc = v2
					}
					else {
						pc += 3
					}
					
				case .jumpIfFalse:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					let v2 = value(at: pc + 2, mode: parameter.modes[1])
					if v1 == 0 {
						pc = v2
					}
					else {
						pc += 3
					}
					
				case .lessThan:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					let v2 = value(at: pc + 2, mode: parameter.modes[1])
					var result = 0
					if v1 < v2 {
						result = 1
					}
					write(result, to: pc + 3, mode: parameter.modes[2])
					pc += 4
					
				case .equals:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					let v2 = value(at: pc + 2, mode: parameter.modes[1])
					var result = 0
					if v1 == v2 {
						result = 1
					}
					write(result, to: pc + 3, mode: parameter.modes[2])
					pc += 4
					
				case .baseOffset:
					let v1 = value(at: pc + 1, mode: parameter.modes[0])
					relativeBase += v1
					pc += 2
					
				case .halt:
					break
				}
			}
			
			return outputs.map({ String($0) }).joined(separator: ",")
		}
	}
	
	enum Operation: Int {
		case nop = 0
		case add = 1
		case mult = 2
		case input = 3
		case output = 4
		case jumpIfTrue = 5
		case jumpIfFalse = 6
		case lessThan = 7
		case equals = 8
		case baseOffset = 9
		case halt = 99
		
		var numParameters: Int {
			switch self {
			case .add, .mult, .lessThan, .equals: return 3
			case .jumpIfTrue, .jumpIfFalse: return 2
			case .input, .output, .baseOffset: return 1
			default: return 0
			}
		}
	}
	
	enum Mode: Int {
		case position = 0
		case immediate = 1
		case relative = 2
	}
	
	struct Parameter {
		var op: Operation
		var modes: [Mode]
		
		init(from code: Int) {
			if code < 100 {
				op = Operation(rawValue: code) ?? .nop
				modes = [Mode](repeating: .position, count: op.numParameters)
			}
			else {
				let digits = Array(String(code).compactMap({ Int(String($0)) }).reversed())
				
				let baseCode = digits[0] + digits[1] * 10
				op = Operation(rawValue: baseCode) ?? .nop
				modes = []
				
				let numParameters = op.numParameters
				for index in 0..<numParameters {
					if index + 2 < digits.count {
						modes.append(Mode(rawValue: digits[index + 2]) ?? .position)
					}
					else {
						modes.append(.position)
					}
				}
			}
		}
	}
}
