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
    
    var toDo: ToDo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
