//
//  Puzzle14_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/14/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle14_1: Puzzle {
	static let day = 14
	static let puzzle = 1

	static func solve(input: String) -> String {
		let nanofactory = Nanofactory(with: input)
		
		return String(nanofactory.oreNeeded(toMake: 1, of: "FUEL"))
	}
	
	class Nanofactory {
		var ratios: [Ratio] = []
		var excess: [Component] = []
		
		init(with input: String) {
			ratios = input.components(separatedBy: .newlines).sorted().compactMap({ Ratio(from: $0) })
			excess = []
		}
		
		
		func oreNeeded(toMake quantity: Int, of type: String) -> Int {
			guard type != "ORE" else {
				return quantity
			}
			
			guard let ratio = ratios.first(where: \.output.type, is: type) else { return 0 }
			
			var needed = quantity
			let production = ratio.output.quantity
			var scale = 1
			
			if let excess = getExcess(of: type) {
				if needed < excess.quantity {
					addExcess(excess.quantity - needed, of: type)
					return 0
				}
				else if needed == excess.quantity {
					return 0
				}
				else {
					needed -= excess.quantity
				}
			}
			
			if production < needed {
				scale = Int((Double(needed) / Double(production)).rounded(.up))
			}
			
			var total = 0
			for input in ratio.inputs {
				total += oreNeeded(toMake: input.quantity * scale, of: input.type)
			}
			
			if needed < (production * scale) {
				addExcess((production * scale) - needed, of: type)
			}
			
			return total
		}
		
		func addExcess(_ quantity: Int, of type: String) {
			if let index = excess.firstIndex(where: { $0.type == type }) {
				excess[index].quantity += quantity
			}
			else {
				excess.append(Component(quantity: quantity, type: type))
			}
		}
		
		func getExcess(of type: String) -> Component? {
			if let index = excess.firstIndex(where: { $0.type == type }) {
				return excess.remove(at: index)
			}
			
			return nil
		}
		
		struct Ratio {
			var inputs: [Component]
			var output: Component
			
			init?(from string: String) {
				let comps = string.components(separatedBy: " => ")
				guard comps.count == 2 else { return nil }
				
				let inputs = comps[0].components(separatedBy: ", ").compactMap({ Component(from: $0) })
				guard !inputs.isEmpty, let output = Component(from: comps[1]) else { return nil }
				
				self.inputs = inputs
				self.output = output
			}
		}
		
		struct Component {
			var quantity: Int
			var type: String
			
			init(quantity: Int, type: String) {
				self.quantity = quantity
				self.type = type
			}
			
			init?(from string: String) {
				let comps = string.components(separatedBy: " ")
				guard comps.count == 2, let quantity = Int(comps[0]) else { return nil }
				
				self.quantity = quantity
				self.type = comps[1]
			}
		}
	}
}
