//
//  NoteTableViewCell.swift
//  Stepik
//
//  Created by Nikita Skrypchenko  on 7/25/19.
//  Copyright © 2019 iosdev. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        super.setSelected(selected, animated: animated)
        if selected {
            colorView.backgroundColor = color
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            colorView.backgroundColor = color
        }
    }
}
