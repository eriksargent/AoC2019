//
//  Puzzle6_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/6/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle6_1: Puzzle {
	static let day = 6
	static let puzzle = 1
	
	static func solve(input: String) -> String {
		let comNode = inputNodes(for: input)
		return String(comNode.countOrbits(level: 0))
	}
	
	static func inputNodes(for input: String) -> Node {
		let terms = input.components(separatedBy: .whitespacesAndNewlines)
		
		// Sort the nodes, then find the next node that we can add. So if we start with the COM, find all nodes that orbit the COM. then for each of those nodes that were added, find the nodes that orbit those nodes. This is MUCH faster than just looping over and over the list of orbits. Store the nodes that can be checked for in a stack, and process them one at a time. This lets us only check each node once
		
		var orbits = terms.map({ $0.components(separatedBy: ")") }).sorted { (lhs, rhs) -> Bool in
			return lhs[0] < rhs[0]
		}
		
		let comNode = Node(named: "COM", orbiting: nil)
		
		var nextNodes = ["COM"]
		
		while !orbits.isEmpty && !nextNodes.isEmpty {
			let nextNode = nextNodes.removeFirst()
			guard let node = comNode.findNode(named: nextNode) else { continue }

			var removeIndicies: [Int] = []

			var start = 0
			var end = orbits.count - 1
			
			// Find nodes that can be added using a binary search for efficiency.
			while start <= end {
				let mid = (start + end) / 2
				let name = orbits[mid][0]
				if name < nextNode {
					start = mid + 1
				}
				else if nextNode < name {
					end = mid - 1
				}
				else {
					start = mid
					end = mid
					while start > 0 && orbits[start - 1][0] == nextNode {
						start -= 1
					}
					while end < orbits.count - 1 && orbits[end + 1][0] == nextNode {
						end += 1
					}
					break
				}
			}
			
			if start > end {
				continue
			}
			
			for (index, orbit) in orbits[start...end].enumerated() where orbit[0] == nextNode {
				removeIndicies.append(index + start)
				node.addChild(named: orbit[1])
				nextNodes.append(orbit[1])
			}

			for index in removeIndicies.reversed() {
				orbits.remove(at: index)
			}
		}
		
		return comNode
	}
	
	class Node: CustomStringConvertible, CustomDebugStringConvertible, Comparable, Equatable {
		var name: String
		var shouldOrbit: String?
		var parent: Node?
		var children: [Node] = []
		
		init(named name: String, orbiting parent: Node?) {
			self.name = name
			self.parent = parent
		}
		
		func addChild(named name: String) {
			let child = Node(named: name, orbiting: self)
//			children.append(child)
//			children.sort()
			children.orderedInsert(child)
		}
		
		func findNode(named name: String) -> Node? {
			if self.name == name { return self }
			
			for child in children {
				if let target = child.findNode(named: name) {
					return target
				}
			}
			
			return nil
		}
		
		func countOrbits(level: Int) -> Int {
			var count = level
			for child in children {
				count += child.countOrbits(level: level + 1)
			}
			
			return count
		}
		
		func describe(at level: Int) -> String {
			var desc = String(repeating: "  ", count: level) + "\(parent?.name ?? ""))\(name)\n"
			for child in children {
				desc += child.describe(at: level + 1)
			}
			
			return desc
		}
		
		var description: String {
			return describe(at: 0)
		}
		
		var debugDescription: String {
			return "\(parent?.name ?? ""))\(name)"
		}
		
		static func == (lhs: Node, rhs: Node) -> Bool {
			return lhs.name == rhs.name
		}
		
		static func < (lhs: Node, rhs: Node) -> Bool {
			return lhs.name < rhs.name
		}
	}
}
