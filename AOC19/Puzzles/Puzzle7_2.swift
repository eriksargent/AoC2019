//
//  Puzzle7_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/7/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle7_2: Puzzle {
	static let day = 7
	static let puzzle = 2

	static func solve(input: String) -> String {
		var possibilities = [Int](repeating: 0, count: 5)
		
		DispatchQueue.concurrentPerform(iterations: 5) { order in
			possibilities[order] = findBestSequence(phase: 1, sequence: "\(order + 5)", instructions: input)
		}
		
		return String(possibilities.max() ?? 0)
	}
	
	static func findBestSequence(phase: Int, sequence: String, instructions: String) -> Int {
		var best = 0
		for order in 5..<10 {
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
		
		var outputPower = 0
		var stages: [IntCode] = []
		for phase in phases {
			let phaseInput = "\(phase),\(outputPower)"
			let stage = IntCode(with: instructions)
			outputPower = stage.process(input: phaseInput)
			stages.append(stage)
		}
		
		var halted = false
		
		while !halted {
			for stage in stages {
				let newOutput = stage.process(input: "\(outputPower)")
				if newOutput == 0 {
					return outputPower
				}
				outputPower = newOutput
				halted = halted || stage.halted
			}
		}
		
		return outputPower
	}
	
	
	class IntCode {
		let instructions: String
		private var opcodes: [Int] = []
		private var pc = 0
		private var lastOutput = 0
		var halted = false
		
		init(with instructions: String) {
			self.instructions = instructions
			
			self.reset()
		}
		
		init(from: IntCode) {
			self.instructions = from.instructions
			self.opcodes = from.opcodes
			self.pc = from.pc
			self.lastOutput = from.lastOutput
		}
		
		func reset() {
			opcodes = instructions.components(separatedBy: ",").map({ Int($0) ?? 0 })
			pc = 0
		}
		
		func copy() -> IntCode {
			return IntCode(from: self)
		}
		
		func process(input: String) -> Int {
			var inputs: [Int] = input.components(separatedBy: ",").compactMap({ Int($0) })
			
			while opcodes[pc] != Operation.halt.rawValue {
				let parameter = Parameter(from: opcodes[pc])
				
				switch parameter.op {
				case .nop:
					pc += 1
					
				case .add:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					let p2 = opcodes[pc + 2]
					let v2 = parameter.modes[1] == .position ? opcodes[p2] : p2
					let p3 = opcodes[pc + 3]
					opcodes[p3] = v1 + v2
					pc += 4
					
				case .mult:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					let p2 = opcodes[pc + 2]
					let v2 = parameter.modes[1] == .position ? opcodes[p2] : p2
					let p3 = opcodes[pc + 3]
					opcodes[p3] = v1 * v2
					pc += 4
					
				case .input:
					let p1 = opcodes[pc + 1]
					if !inputs.isEmpty {
						let input = inputs.remove(at: 0)
						opcodes[p1] = input
					}
					else {
						return lastOutput
					}
					pc += 2
					
				case .output:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					lastOutput = v1
					pc += 2
					
				case .jumpIfTrue:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					let p2 = opcodes[pc + 2]
					let v2 = parameter.modes[1] == .position ? opcodes[p2] : p2
					if v1 != 0 {
						pc = v2
					}
					else {
						pc += 3
					}
					
				case .jumpIfFalse:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					let p2 = opcodes[pc + 2]
					let v2 = parameter.modes[1] == .position ? opcodes[p2] : p2
					if v1 == 0 {
						pc = v2
					}
					else {
						pc += 3
					}
					
				case .lessThan:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					let p2 = opcodes[pc + 2]
					let v2 = parameter.modes[1] == .position ? opcodes[p2] : p2
					let p3 = opcodes[pc + 3]
					if v1 < v2 {
						opcodes[p3] = 1
					}
					else {
						opcodes[p3] = 0
					}
					pc += 4

				case .equals:
					let p1 = opcodes[pc + 1]
					let v1 = parameter.modes[0] == .position ? opcodes[p1] : p1
					let p2 = opcodes[pc + 2]
					let v2 = parameter.modes[1] == .position ? opcodes[p2] : p2
					let p3 = opcodes[pc + 3]
					if v1 == v2 {
						opcodes[p3] = 1
					}
					else {
						opcodes[p3] = 0
					}
					pc += 4
					
				case .halt:
					halted = true
					return lastOutput
				}
			}
			
			halted = true
			return lastOutput
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
		case halt = 99
		
		var numParameters: Int {
			switch self {
			case .add, .mult, .lessThan, .equals: return 3
			case .jumpIfTrue, .jumpIfFalse: return 2
			case .input, .output: return 1
			default: return 0
			}
		}
	}
	
	enum Mode: Int {
		case position = 0
		case immediate = 1
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
