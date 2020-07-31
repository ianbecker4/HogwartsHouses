//
//  CoreDataStack.swift
//  HogwartsHouses
//
//  Created by Ian Becker on 7/30/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
        static let container: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "HogwartsHouses")
            container.loadPersistentStores() { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        static var context: NSManagedObjectContext {return container.viewContext}
}
