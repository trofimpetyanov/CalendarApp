//
//  HourTableViewCell.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 03.06.2022.
//

import UIKit

class HourTableViewCell: UITableViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // TODO: Configure cell with ToDo model
    func configureCell() {
        
    }
}
