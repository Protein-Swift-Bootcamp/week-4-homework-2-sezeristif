//
//  CustomTableViewCell.swift
//  bootcamp-week-4
//
//  Created by Sezer Istif on 3.01.2023.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
