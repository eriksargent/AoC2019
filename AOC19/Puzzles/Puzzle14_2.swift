//
//  Puzzle14_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/14/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle14_2: Puzzle {
	static let day = 14
	static let puzzle = 2

	static func solve(input: String) -> String {
		let nanofactory = Nanofactory(with: input)
		
		return String(nanofactory.fuelProduced(byOre: 1_000_000_000_000))
	}
	
	class Nanofactory {
		var ratios: [Ratio] = []
		var excess: [Component] = []
		
		init(with input: String) {
			ratios = input.components(separatedBy: .newlines).sorted().compactMap({ Ratio(from: $0) })
			excess = []
		}
		
		func fuelProduced(byOre ore: Int) -> Int {
			addExcess(ore, of: "ORE")
			
			var lastExcess = excess
			var fuelProduced = 0
			var amount = 400_000_000
			while amount > 0 {
				while canMake(amount: amount, of: "FUEL") {
					fuelProduced += amount
					lastExcess = excess
				}
				excess = lastExcess
				amount /= 2
				
			}

			return fuelProduced
		}
		
		func canMake(amount quantity: Int, of type: String) -> Bool {
			guard type != "ORE" else {
				if let excess = getExcess(of: type) {
					if quantity < excess.quantity {
						addExcess(excess.quantity - quantity, of: type)
						return true
					}
					else if quantity == excess.quantity {
						return true
					}
					else {
						addExcess(excess.quantity, of: type)
						return false
					}
				}
				else {
					return false
				}
			}
			
			guard let ratio = ratios.first(where: \.output.type, is: type) else { return false }
			
			var needed = quantity
			let production = ratio.output.quantity
			var scale = 1
			
			if let excess = getExcess(of: type) {
				if needed < excess.quantity {
					addExcess(excess.quantity - needed, of: type)
					return true
				}
				else if needed == excess.quantity {
					return true
				}
				else {
					needed -= excess.quantity
				}
			}
			
			if production < needed {
				scale = Int((Double(needed) / Double(production)).rounded(.up))
			}
			
			for input in ratio.inputs {
				if !canMake(amount: input.quantity * scale, of: input.type) {
					return false
				}
			}
			
			if needed < (production * scale) {
				addExcess((production * scale) - needed, of: type)
			}
			
			return true
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
