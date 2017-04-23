//
//  StatisticsTable.swift
//  Pokulator
//
//  Created by Edward Huang on 4/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

class StatisticsTable: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data = [GenericHand : Double]()

    func getData(data: [GenericHand : Double]) -> Void {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StatisticsTableCell else {
            fatalError("The dequeued cell is not an instance of StatisticsTableCell.")
        }
        
        let hand1 = GenericHand(rawValue: indexPath.row * 2)!
        let hand2 = GenericHand(rawValue: indexPath.row * 2 + 1)
        
        if let value1 = data[hand1] {
            cell.title1.text = toString(hand: hand1) + ":"
            if value1 == 0 || value1 == Double.nan {
                cell.label1.text = "-"
            } else {
                cell.label1.text = "\((value1*1000).rounded() / 1000.0)"
            }
        } else {
            cell.label1.text = "-"
        }
        
        if indexPath.row == 4 {
            cell.title2.text = "Winning:"
            cell.label2.text = "-"
        } else {
            if let value2 = data[hand2!] {
                cell.title2.text = toString(hand: hand2!) + ":"
                if value2 == 0 || value2 == Double.nan {
                    cell.label2.text = "-"
                }
                cell.label2.text = "\((value2*1000).rounded() / 1000.0)"
            } else {
                cell.label2.text = "-"
            }
        }
        
        return cell
    }
}
