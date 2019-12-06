//
//  Puzzle6_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/6/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle6_2: Puzzle {
	static let day = 6
	static let puzzle = 2

	static func solve(input: String) -> String {
		let comNode = Puzzle6_1.inputNodes(for: input)
		let you = comNode.findNode(named: "YOU")
		
		if let jumps = you?.jumpsTo("SAN", from: nil) {
			return String(jumps)
		}
		else {
			return ""
		}
	}
}


extension Puzzle6_1.Node {
	func jumpsTo(_ targetName: String, from: Puzzle6_1.Node?) -> Int? {
		if name == targetName {
			return -2
		}
		
		for child in children where child.name != from?.name {
			if let jumps = child.jumpsTo(targetName, from: self) {
				return jumps + 1
			}
		}
		
		if parent?.name != from?.name, let jumps = parent?.jumpsTo(targetName, from: self) {
			return jumps + 1
		}
		
		return nil
	}
}
