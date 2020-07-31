//
//  HouseGuessController.swift
//  HogwartsHouses
//
//  Created by Ian Becker on 7/30/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import CoreData

class HouseGuessController {
    
    // MARK: - Singleton
    static let shared = HouseGuessController()
    
    // MARK: - Class Properties
    var fetchedResultsController: NSFetchedResultsController<HouseGuess>
    
    init() {
        let request: NSFetchRequest<HouseGuess> = HouseGuess.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "isVisible", ascending: false)]
        
        let resultsController: NSFetchedResultsController<HouseGuess> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isVisible", cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch.")
        }
    }
    
    // MARK: - CRUD
    func createGuess(guessName: String, house: String) {
        _ = HouseGuess(guessName: guessName, house: house)
        saveToPersistence()
    }
    
    func updateVisibility(houseGuess: HouseGuess) {
        houseGuess.isVisible = !houseGuess.isVisible
        saveToPersistence()
    }
    
    func remove(houseGuess: HouseGuess) {
        let moc = CoreDataStack.context
        moc.delete(houseGuess)
        saveToPersistence()
    }
    
    // MARK: - Persistence
    func saveToPersistence() {
        let moc = CoreDataStack.context
        do {
            try moc.save()
        } catch {
            print("Error saving to persistent store.")
        }
    }
}
