//
//  StatsUpdater.swift
//  Pokulator
//
//  Created by Edward Huang on 4/30/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

func updateStats(stats: [UILabel]!, handData: [GenericHand:Double], win: Double) -> Void {
    stats[9].text = "\((win*100).rounded() / 100.0)"
    for i in 0...8 {
        let value = handData[GenericHand(rawValue: i)!]!
        if value == 0.0 {
            stats[i].text = "-"
        } else {
            stats[i].text = "\((value * 100).rounded() / 100.0)"
        }
    }
}
