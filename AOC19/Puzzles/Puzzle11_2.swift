//
//  Puzzle11_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/12/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle11_2: Puzzle {
	static let day = 11
	static let puzzle = 2

	static func solve(input: String) -> String {
		let computer = IntCode(with: input)
		
		let width = 150
		let height = 150
		var hull = HullPaint(width: width, height: height)
		
		var point = Point(x: width / 2, y: height / 2)
		var dir = Direction.up
		
		while computer.halted == false {
			let color = hull[point.x, point.y].colorValue
			let outputs = computer.process(input: [color])
			
			guard outputs.count == 2 else { break }
			
			let newColor = outputs[0]
			let turn = outputs[1]
			
			hull[point.x, point.y] = .color(from: newColor)
			if turn == 0 {
				dir = dir.rotate90Left
			}
			else {
				dir = dir.rotate90Right
			}
			
			point = point + CardinalVector(direction: dir, distance: 1)
		}
		
		return String(describing: hull)
	}
	
	
	struct HullPaint: CustomStringConvertible {
		var width: Int
		var height: Int
		
		enum Color: Int, CustomStringConvertible {
			case black = 0
			case white = 1
			case unknown = -1
			
			var colorValue: Int {
				switch self {
				case .black:
					return 0
				case .white, .unknown:
					return 1
				}
			}
			
			static func color(from value: Int) -> Color {
				switch value {
				case 0:
					return .black
				case 1:
					return .white
				default:
					return .unknown
				}
			}
			
			var description: String {
				switch self {
				case .black:
					return "▪️"
				case .white:
					return "▫️"
				case .unknown:
					return " "
				}
			}
		}
		
		var colors: [Color]
		
		init(width: Int, height: Int) {
			self.width = width
			self.height = height
			self.colors = [Color](repeating: .unknown, count: width * height)
		}
		
		subscript(x: Int, y: Int) -> Color {
			get {
				return colors[x + y * width]
			}
			set {
				colors[x + y * width] = newValue
			}
		}
		
		var description: String {
			var rows: [String] = []
			for row in 0..<height {
				var string = ""
				for col in 0..<width {
					string += "\(self[col, row])"
				}
				rows.append(string)
			}
			return rows.joined(separator: "\n")
		}
	}
	
	
	class IntCode {
		let instructions: String
		var halted = false
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
		
		func value(at position: Int, mode: Mode) -> Int {
			let pos = opcodes[position]
			
			switch mode {
			case .position:
				return opcodes[pos]
			case .immediate:
				return pos
			case .relative:
				let relative = relativeBase + opcodes[position]
				return opcodes[relative]
			}
		}
		
		func write(_ value: Int, to position: Int, mode: Mode) {
			let pos = opcodes[position]
			
			switch mode {
			case .position:
				opcodes[pos] = value
			case .immediate:
				break
			case .relative:
				let relative = relativeBase + pos
				opcodes[relative] = value
			}
		}
		
		func reset() {
			let comps = instructions.components(separatedBy: ",").compactMap({ Int($0) })
			opcodes = [Int](repeating: 0, count: 3000)
			opcodes[0..<comps.count] = comps[0..<comps.count]
			pc = 0
		}
		
		func copy() -> IntCode {
			return IntCode(from: self)
		}
		
		func process(input: [Int]) -> [Int] {
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
						return outputs
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
					halted = true
					return outputs
				}
			}
			
			return outputs
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
		
		static let emptyModes1: [Mode] = [.position]
		static let emptyModes2: [Mode] = [.position, .position]
		static let emptyModes3: [Mode] = [.position, .position, .position]
		static let emptyModes4: [Mode] = [.position, .position, .position, .position]
	}
	
	struct Parameter {
		var op: Operation
		var modes: [Mode]
		
		init(from code: Int) {
			if code < 100 {
				op = Operation(rawValue: code) ?? .nop
				
				// This provides a nice speedup for larger puzzles by avoiding a good number of calls to create a new array
				let numParameters = op.numParameters
				switch numParameters {
				case 0: modes = []
				case 1: modes = Mode.emptyModes1
				case 2: modes = Mode.emptyModes2
				case 3: modes = Mode.emptyModes3
				case 4: modes = Mode.emptyModes4
					
				default:
					modes = [Mode](repeating: .position, count: numParameters)
				}
			}
			else {
				var inputCode = code
				
				let baseCode = inputCode % 100
				inputCode /= 100
				op = Operation(rawValue: baseCode) ?? .nop
				modes = []
				
				let numParameters = op.numParameters
				for _ in 0..<numParameters {
					let digit = inputCode % 10
					inputCode /= 10
					modes.append(Mode(rawValue: digit) ?? .position)
				}
			}
		}
	}
}
