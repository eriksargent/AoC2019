//
//  Model.swift
//  AOC19
//
//  Created by Erik Sargent on 12/2/19.
//  Copyright © 2019 ErikSargent. All rights reserved.
//

import Foundation
import CoreData


class Model {
	struct DataController {
		let context: NSManagedObjectContext
		
		/// Perform the operations on the context
		func performAndWait(_ function: () -> ()) {
			context.performAndWait {
				function()
			}
		}
		
		/// Perform the operations on the context
		func performAndWait(_ function: (DataController) -> ()) {
			context.performAndWait {
				function(self)
			}
		}
		
		/// Perform the operations on the context
		func perform(_ function: @escaping () -> ()) {
			context.perform {
				function()
			}
		}
		
		/// Perform the operations on the context
		func perform(_ function: @escaping (DataController) -> ()) {
			context.perform {
				function(self)
			}
		}
		
		func save() {
			if context.hasChanges {
				do {
					try context.save()
				} catch {
					let nserror = error as NSError
					print("\n\n‼️ Unresolved error saving to context: \(nserror), \(nserror.userInfo)\n\n")
				}
			}
		}
		
		/// Dispatches to the context's queue and saves the context
		func asyncSave() {
			perform {
				self.save()
			}
		}
		
		/// Dispatches to the context's queue and saves the context
		func blockingSave() {
			performAndWait {
				self.save()
			}
		}
	}
	
	
	// MARK: - Properties
    fileprivate static let sharedModel = Model()
	fileprivate var mainContextChangeNotificationObserver: NSObjectProtocol?
	fileprivate var backgroundContextChangeNotificationObserver: NSObjectProtocol?
	var context: NSManagedObjectContext
	
	var main: DataController
	
	static var main: DataController {
		return sharedModel.main
	}
	
	init() {
		context = Model.persistentContainer.viewContext
		context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
		
		main = DataController(context: context)
	}
	
	
    // MARK: - Core Data stack
	static fileprivate var persistentContainer: NSPersistentContainer = {
		return initContainer()
	}()
	
	static fileprivate func initContainer() -> NSPersistentContainer {
		/*
		The persistent container for the application. This implementation
		creates and returns a container, having loaded the store for the
		application to it. This property is optional since there are legitimate
		error conditions that could cause the creation of the store to fail.
		*/
		let container = NSPersistentContainer(name: "Model")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			
			if let location = storeDescription.url {
				print("\n🗂  \(location.path)\n")
			}
			
			if let error = error as NSError? {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				
				/*
				Typical reasons for an error here include:
				* The parent directory does not exist, cannot be created, or disallows writing.
				* The persistent store is not accessible, due to permissions or data protection when the device is locked.
				* The device is out of space.
				* The store could not be migrated to the current model version.
				Check the error message to determine what the actual problem was.
				*/
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		
		return container
	}
}
