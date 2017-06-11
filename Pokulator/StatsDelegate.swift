//
//  StatsUpdater.swift
//  Pokulator
//
//  Created by Edward Huang on 4/30/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit


protocol StatsDelegate {
    func updateStats(handData: [GenericHand:Double], win: Double)
}
