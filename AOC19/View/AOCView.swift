//
//  AOCView.swift
//  AOC19
//
//  Created by Erik Sargent on 12/2/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import SwiftUI
import Cocoa
import CoreData


struct AOCView: View {
	@Environment(\.managedObjectContext) var context
	
	@State private var timeAllResultsString: String = ""
	
	var body: some View {
		NavigationView {
			VStack {
				List(0..<Puzzles.puzzles.count) { puzzleIndex in
					PuzzleListItem(puzzle: Puzzles.puzzles[puzzleIndex])
				}
				.listStyle(SidebarListStyle())
				
				Button(action: {
					self.timeNext(index: 0, time: 0, summary: "")
				}, label: {
					Text("Time All")
				})
					.padding()
				
				Text(self.timeAllResultsString)
					.padding()
			}
		}
		.touchBar {
			Button(action: {
				self.timeNext(index: 0, time: 0, summary: "")
			}, label: {
				Text("Time All")
			})
		}
	}
	
	private func timeNext(index: Int, time: TimeInterval, summary: String) {
		let puzzles = Puzzles.puzzles
		guard index < puzzles.count else {
			self.timeAllResultsString = "All puzzles tested in \(PuzzleDetails.format(time: time))"
			
			let generatedReadme = readmeHeader + summary + "\n| **Total** | | \(PuzzleDetails.format(time: time)) |\n"
			let data = generatedReadme.data(using: .utf8)
			let filename = "README.md"
			let savePanel = NSSavePanel()
			savePanel.nameFieldStringValue = filename
			savePanel.begin { _ in
				if let url = savePanel.url {
					FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
				}
			}
			
			return
		}
		
		let puzzle = puzzles[index]
		
		do {
			let fetchRequest = PuzzleEntry.fetchRequest() as NSFetchRequest<PuzzleEntry>
			fetchRequest.predicate = NSPredicate(format: "%K == %ld && %K == %ld", #keyPath(PuzzleEntry.day), puzzle.day, #keyPath(PuzzleEntry.puzzle), puzzle.puzzle)
			fetchRequest.fetchLimit = 1
			
			if let entry = try self.context.fetch(fetchRequest).first, let input = entry.input {
				puzzle.timeAndSolve(input: input) { (_, puzzleTime) in
					let newSummary = summary + "\n| \(puzzle.day) | \(puzzle.puzzle) | \(PuzzleDetails.format(time: puzzleTime)) |"
					self.timeNext(index: index + 1, time: time + puzzleTime, summary: newSummary)
				}
			}
			else {
				timeNext(index: index + 1, time: time, summary: summary)
			}
		}
		catch _ {
			timeNext(index: index + 1, time: time, summary: summary)
		}
	}
	
	private var readmeHeader: String {
		return "# Advent of Code 2019 Solutions\n\nThese are my solutions for [Advent of Code 2019](https://adventofcode.com/2019). All written in [Swift](https://swift.org), and targeted for macOS 10.15.\n\nBelow is a summary of the execution times for each puzzle's solution. \n\n### Execution Time\n| Day | Puzzle | Time |\n| :---: | :---: | :---: |"
	}
}


struct PuzzleListItem: View {
	var puzzle: Puzzle.Type
	
	var body: some View {
		NavigationLink(puzzle.name, destination: PuzzleDetails(puzzle: puzzle))
	}
}


#if DEBUG
    struct AOCView_Previews: PreviewProvider {
        static var previews: some View {
            AOCView()
        }
    }
#endif
