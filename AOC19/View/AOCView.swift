//
//  AOCView.swift
//  AOC19
//
//  Created by Erik Sargent on 12/2/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import SwiftUI
import CoreData


struct AOCView: View {
	@Environment(\.managedObjectContext) var context
	
	@State private var showTimeAllAlert: Bool = false
	@State private var timeAlertString: String = ""
	
	var body: some View {
		NavigationView {
			VStack {
				List(0..<Puzzles.puzzles.count) { puzzleIndex in
					PuzzleListItem(puzzle: Puzzles.puzzles[puzzleIndex])
				}
				.listStyle(SidebarListStyle())
				
				Button(action: {
					self.timeNext(index: 0, time: 0)
				}, label: {
					Text("Time All")
				})
				.padding()
			}
		}
		.alert(isPresented: self.$showTimeAllAlert) {
			Alert(title: Text("AOC 2019"), message: Text(self.timeAlertString))
		}
		.touchBar {
			Button(action: {
				self.timeNext(index: 0, time: 0)
			}, label: {
				Text("Time All")
			})
		}
	}
	
	private func timeNext(index: Int, time: TimeInterval) {
		let puzzles = Puzzles.puzzles
		guard index < puzzles.count else {
			self.timeAlertString = "All puzzles tested in \(PuzzleDetails.format(time: time))"
			self.showTimeAllAlert = true
			return
		}
		
		let puzzle = puzzles[index]
		
		do {
			let fetchRequest = PuzzleEntry.fetchRequest() as NSFetchRequest<PuzzleEntry>
			fetchRequest.predicate = NSPredicate(format: "%K == %ld && %K == %ld", #keyPath(PuzzleEntry.day), puzzle.day, #keyPath(PuzzleEntry.puzzle), puzzle.puzzle)
			fetchRequest.fetchLimit = 1
			
			if let entry = try self.context.fetch(fetchRequest).first, let input = entry.input {
				puzzle.timeAndSolve(input: input) { (_, puzzleTime) in
					self.timeNext(index: index + 1, time: time + puzzleTime)
				}
			}
			else {
				timeNext(index: index + 1, time: time)
			}
		}
		catch _ {
			timeNext(index: index + 1, time: time)
		}
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
