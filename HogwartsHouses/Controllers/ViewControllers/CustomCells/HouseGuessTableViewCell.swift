//
//  HouseGuessTableViewCell.swift
//  HogwartsHouses
//
//  Created by Ian Becker on 7/30/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class HouseGuessTableViewCell: UITableViewCell {
    
    var guess: HouseGuess? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var personGuessLabel: UILabel!
    @IBOutlet weak var houseImageButton: UIButton!
    
    // MARK: - Action
    @IBAction func houseButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Helpers
    func updateViews() {
        guard let guess = guess else {return}
        personGuessLabel.text = guess.guessName
    }
}
