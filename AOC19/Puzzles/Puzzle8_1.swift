//
//  Puzzle8_1.swift
//  AOC19
//
//  Created by Erik Sargent on 12/8/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle8_1: Puzzle {
	static let day = 8
	static let puzzle = 1

	static func solve(input: String) -> String {
		let comps = input.split(separator: ";")
		guard comps.count == 3 else { return "" }
		guard let width = Int(comps[1]), let height = Int(comps[2]) else { return "" }
		
		let size = width * height
		let data = comps[0].compactMap({ UInt8(String($0)) })
		let dataSize = data.count
		let layers = dataSize / size
		
		var bestLayer = 0
		var bestLayerZeros = Int.max
		
		for layer in 0..<layers {
			let layerData = data[(layer * size)..<((layer + 1) * size)]
			let numZeros = layerData.filter({ $0 == 0 }).count
			if numZeros < bestLayerZeros {
				bestLayer = layer
				bestLayerZeros = numZeros
			}
		}
		
		let layerData = data[(bestLayer * size)..<((bestLayer + 1) * size)]
		var ones = 0
		var twos = 0
		for byte in layerData {
			if byte == 1 {
				ones += 1
			}
			else if byte == 2 {
				twos += 1
			}
		}
		
		return String(ones * twos)
	}
}
