//
//  Puzzle8_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/8/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle8_2: Puzzle {
	static let day = 8
	static let puzzle = 2

	static func solve(input: String) -> String {
		let comps = input.split(separator: ";")
		guard comps.count == 3 else { return "" }
		guard let width = Int(comps[1]), let height = Int(comps[2]) else { return "" }
		
		let size = width * height
		let data = comps[0].compactMap({ UInt8(String($0)) }).map({ Pixel.getPixel(from: $0) })
		let dataSize = data.count
		let layers = dataSize / size
		
		var image = Image(width: width, height: height)
		
		for layer in stride(from: layers, to: 0, by: -1) {
			let layerData = data[((layer - 1) * size)..<((layer) * size)]
			
			for (index, pixel) in layerData.enumerated() where pixel != .transparent {
				image.pixels[index] = pixel
			}
		}
		
		var output = ""
		
		for y in 0..<height {
			for x in 0..<width {
				output += image[x, y].printValue
			}
			if y != height - 1 {
				output += "\n"
			}
		}
		
		return output
	}
	
	enum Pixel: UInt8 {
		case black = 0
		case white = 1
		case transparent = 2
		
		static func getPixel(from value: UInt8) -> Pixel {
			return Pixel(rawValue: value) ?? .transparent
		}
		
		var printValue: String {
			switch self {
			case .black: return "◼︎"
			case .white, .transparent: return "◻︎"
			}
		}
	}
	
	struct Image {
		var pixels: [Pixel]
		var width: Int
		var height: Int
		
		init(width: Int, height: Int) {
			self.width = width
			self.height = height
			self.pixels = [Pixel](repeating: .transparent, count: width * height)
		}
		
		subscript(x: Int, y: Int) -> Pixel {
			get {
				return pixels[x + y * width]
			}
			set {
				pixels[x + y * width] = newValue
			}
		}
	}
}
