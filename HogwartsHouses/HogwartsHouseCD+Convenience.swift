//
//  HogwartsHouseCD+Convenience.swift
//  HogwartsHouses
//
//  Created by Ian Becker on 7/30/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import CoreData

extension HouseGuess {
    
    convenience init(guessName: String, house: String, isVisible: Bool = false, context: NSManagedObjectContext) {
        self.init(context: context)
        self.guessName = guessName
        self.house = house
        self.isVisible = isVisible
    }
}
