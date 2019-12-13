//
//  Puzzle13_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/13/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle13_2: Puzzle {
	static let day = 13
	static let puzzle = 2

	static func solve(input: String) -> String {
		let hackedInput = input.replacingCharacters(in: input.startIndex...input.startIndex, with: "2")
		let comp = Puzzle11_2.IntCode(with: hackedInput)
		
		var game = Puzzle13_1.Game(width: 42, height: 25)
		var score = 0
		var nextInputs: [Int] = []
		
		while !comp.halted {
			let outputs = comp.process(input: nextInputs)
			guard !outputs.isEmpty else { break }
			
			for index in stride(from: 0, through: outputs.count - 2, by: 3) {
				let x = outputs[index]
				let y = outputs[index + 1]
				
				if x == -1 && y == 0 {
					score = outputs[index + 2]
				}
				else {
					let tile = Puzzle13_1.GameTile(rawValue: outputs[index + 2]) ?? .empty
					game[x, y] = tile
				}
			}
			
			if let (ballX, _) = game.find(.ball), let (paddleX, _) = game.find(.paddle) {
				if ballX == paddleX {
					nextInputs = [0]
				}
				else if ballX < paddleX {
					nextInputs = [-1]
				}
				else {
					nextInputs = [1]
				}
			}
			
//			print(game)
		}
		
		return String(score)
	}
}


extension Puzzle13_1.Game {
	func find(_ type: Puzzle13_1.GameTile) -> (x: Int, y: Int)? {
		for y in 0..<height {
			for x in 0..<width {
				if self[x, y] == type {
					return (x: x, y: y)
				}
			}
		}
		
		return nil
	}
}
