//
//  Puzzle16_2.swift
//  AOC19
//
//  Created by Erik Sargent on 12/17/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation


enum Puzzle16_2: Puzzle {
	static let day = 16
	static let puzzle = 2

	static let basePattern = [0, 1, 0, -1]

	static func solve(input: String) -> String {
		let initialData = input.compactMap({ Int(String($0)) })
		var data: [Int] = []
		let offset = Int(input[input.startIndex..<input.index(input.startIndex, offsetBy: 7)])!
		
		for _ in 0..<10000 {
			data.append(contentsOf: initialData)
		}
		
		let inputLength = data.count
		var nextData = data
		
		for _ in 0..<100 {
			var index = inputLength - 2

            while index >= offset {
                nextData[index] = (nextData[index + 1] + data[index]) % 10
                index -= 1
            }
            data = nextData
		}
		
		return data[offset..<(offset + 8)].map({ String($0) }).joined()
	}
}
