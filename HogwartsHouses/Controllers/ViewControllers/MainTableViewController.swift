//
//  MainTableViewController.swift
//  HogwartsHouses
//
//  Created by Ian Becker on 7/30/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HouseGuessController.shared.fetchedResultsController.delegate = self
        
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAlertController()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return HouseGuessController.shared.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HouseGuessController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "guessCell", for: indexPath) as? HouseGuessTableViewCell else {return UITableViewCell()}
        
        let guessToDisplay = HouseGuessController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.guess = guessToDisplay
        cell.delegate = self

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let guessToDelete = HouseGuessController.shared.fetchedResultsController.object(at: indexPath)
            HouseGuessController.shared.remove(houseGuess: guessToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 7
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return HouseGuessController.shared.fetchedResultsController.sectionIndexTitles[section] == "0" ? "Invisibility Cloak" : "Visible"
    }
    
    // MARK: - Helpers
    func presentAlertController() {
        let alertController = UIAlertController(title: "Add House Guess", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person's name..."
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Person's Hogwarts House..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addGuessAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let guessName = alertController.textFields?[0].text, !guessName.isEmpty, let house = alertController.textFields?[1].text, !house.isEmpty else {return}
            
            HouseGuessController.shared.createGuess(guessName: guessName, house: house)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addGuessAction)
        
        present(alertController, animated: true)
    }
} // End of class

extension MainTableViewController: HouseGuessTableViewCellDelegate {
    func houseButtonTapped(_ sender: HouseGuessTableViewCell) {
        guard let index = tableView.indexPath(for: sender) else {return}
        let guess = HouseGuessController.shared.fetchedResultsController.object(at: index)
        HouseGuessController.shared.updateVisibility(houseGuess: guess)
        sender.updateViews()
    }
}

extension MainTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {break}
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else {break}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {break}
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else {break}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            fatalError()
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        default: fatalError()
        }
    }
}
