//
//  Optionals.swift
//  AOC18
//
//  Created by Erik Sargent on 12/3/18.
//  Copyright © 2018 ErikSargent. All rights reserved.
//

import Foundation


//https://stackoverflow.com/a/38548106/866149
protocol OptionalType {
	associatedtype Wrapped
	func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}


extension Optional: OptionalType {}


extension Sequence where Iterator.Element: OptionalType {
	func unwrapped() -> [Iterator.Element.Wrapped] {
		var result: [Iterator.Element.Wrapped] = []
		for element in self {
			if let element = element.map({ $0 }) {
				result.append(element)
			}
		}
		return result
	}
}

