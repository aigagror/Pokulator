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
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        if let value = data[GenericHand(rawValue: indexPath.row)!] {
            cell.textLabel?.text = toString(hand: GenericHand(rawValue: indexPath.row)!) + " : " + "\(value)"
        }
        return cell
    }
}
