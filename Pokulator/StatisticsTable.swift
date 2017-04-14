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
        return (data.count + 1) / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StatisticsTableCell else {
            fatalError("The dequeued cell is not an instance of StatisticsTableCell.")
        }
        
        let hand1 = GenericHand(rawValue: indexPath.row * 2)!
        let hand2 = GenericHand(rawValue: indexPath.row * 2 + 1)!
        
        if let value1 = data[hand1] {
            cell.label1.text = toString(hand: hand1) + " : \(value1)"
        }
        if let value2 = data[hand2] {
            cell.label2.text = toString(hand: hand2) + " : \(value2)"
        } else {
            cell.label2.text = ""
        }
        return cell
    }
}
