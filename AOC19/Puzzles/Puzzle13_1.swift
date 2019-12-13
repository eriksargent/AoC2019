//
//  Puzzle13_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/13/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle13_1: Puzzle {
	static let day = 13
	static let puzzle = 1

	static func solve(input: String) -> String {
		let comp = Puzzle11_2.IntCode(with: input)
		
		let outputs = comp.process(input: [])
		var game = Game(width: 42, height: 25)
		
		for index in stride(from: 0, through: outputs.count - 2, by: 3) {
			let x = outputs[index]
			let y = outputs[index + 1]
			let tile = GameTile(rawValue: outputs[index + 2]) ?? .empty
			
			game[x, y] = tile
		}
		
		let blockTiles = game.grid.filter({ $0 == .block }).count
		
		return String(blockTiles)
	}
	
	enum GameTile: Int {
		case empty = 0
		case wall
		case block
		case paddle
		case ball
		
		var stringValue: String {
			switch self {
			case .empty: return " "
			case .wall: return "|"
			case .block: return "◼︎"
			case .paddle: return "_"
			case .ball: return "◦"
			}
		}
	}
	
	struct Game: CustomStringConvertible {
		var grid: [GameTile]
		var width: Int
		var height: Int
		
		init(width: Int, height: Int) {
			self.width = width
			self.height = height
			self.grid = [GameTile](repeating: .empty, count: width * height)
		}
		
		subscript(x: Int, y: Int) -> GameTile {
			get {
				return grid[x + y * width]
			}
			set {
				grid[x + y * width] = newValue
			}
		}
		
		var description: String {
			var rows = [String]()
			for y in 0..<height {
				var col = ""
				for x in 0..<width {
					col += self[x, y].stringValue
				}
				rows.append(col)
			}
			return rows.joined(separator: "\n")
		}
	}
}
