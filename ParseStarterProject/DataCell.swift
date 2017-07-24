//
//  DataCell.swift
//  ParseStarterProject-Swift
//
//  Created by Christopher Chu on 7/22/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {

    @IBOutlet weak var label: UILabel! //label on the cell that has a class name
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) //animate the cell

        // Configure the view for the selected state
    }
    
    func configureCell(text: String) {
        label.text = text //set the label text
    }

}
