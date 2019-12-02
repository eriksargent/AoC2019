//
//  PuzzleDetails.swift
//  AOC19
//
//  Created by Erik Sargent on 12/2/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import SwiftUI
import CoreData


struct PuzzleDetails: View {
	@Environment(\.managedObjectContext) var context
	
	var puzzle: Puzzle.Type
	
	@State private var puzzleInput: String = ""
	@State private var puzzleOutput: String = ""
	@State private var time: String = "0sec"
	@State private var puzzleEntry: PuzzleEntry?
	
	var body: some View {
		VStack(alignment: .center) {
			Text(puzzle.name)
				.font(.title)
			
			Spacer()
			
			ScrollView {
				TextField("Input", text: self.$puzzleInput, onCommit: {
					self.process()
				})
			}
			
			Button(action: {
				self.process()
			}, label: { Text("Process Puzzle") })
			
			Group {
				Spacer()
				Divider()
				Spacer()
			}
			
			Text(self.puzzleOutput)
				.onTapGesture {
					let pasteboard = NSPasteboard.general
					pasteboard.clearContents()
					pasteboard.setString(self.puzzleOutput, forType: .string)
				}
			
			Group {
				Spacer()
				Divider()
				Spacer()
			}
			
			Text("Time: \(self.time)")
				.font(.caption)
		}
		.padding()
		.touchBar {
			Button(action: self.process, label: { Text("Process Puzzle") })
		}
		.onAppear {
			self.puzzleInput = ""
			self.puzzleOutput = ""
			self.time = ""
			self.puzzleEntry = nil
			
			do {
				let fetchRequest = PuzzleEntry.fetchRequest() as NSFetchRequest<PuzzleEntry>
				fetchRequest.predicate = NSPredicate(format: "%K == %ld && %K == %ld", #keyPath(PuzzleEntry.day), self.puzzle.day, #keyPath(PuzzleEntry.puzzle), self.puzzle.puzzle)
				fetchRequest.fetchLimit = 1
				self.puzzleEntry = try self.context.fetch(fetchRequest).first
				
				if let entry = self.puzzleEntry {
					self.puzzleInput = entry.input ?? ""
					self.puzzleOutput = entry.output ?? ""
					self.time = self.format(time: entry.time)
				}
			}
			catch _ {}
		}
	}
	
	private func process() {
		self.puzzleOutput = ""
		self.time = ""
		
		let input = self.puzzleInput
		self.puzzle.timeAndSolve(input: input) { (result, time) in
			self.puzzleOutput = result
			self.time = self.format(time: time)
			
			var entry: PuzzleEntry
			if let puzzleEntry = self.puzzleEntry {
				entry = puzzleEntry
			}
			else {
				entry = PuzzleEntry(context: self.context)
				entry.day = Int64(self.puzzle.day)
				entry.puzzle = Int64(self.puzzle.puzzle)
			}
			
			entry.input = input
			entry.output = result
			entry.time = time
			
			Model.main.asyncSave()
		}
	}
	
	func format(time: Double) -> String {
		return PuzzleDetails.format(time: time)
	}
	
	static func format(time: Double) -> String {
		let formatter = MeasurementFormatter()
		let runningTime = formatter.string(from: Measurement<UnitDuration>(value: time, unit: .seconds))
		return runningTime
	}
}

struct PuzzleDetails_Previews: PreviewProvider {
    static var previews: some View {
		PuzzleDetails(puzzle: Puzzles.puzzles.first!)
    }
}
