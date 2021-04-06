//
//  AnswerTableViewCell.swift
//  Word Scrambler - Final
//
//  Created by Ankit Shah on 2/26/21.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet var cellLabel: UILabel!
    @IBOutlet var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellButton.layer.borderWidth = 0.5
        cellButton.layer.borderColor = cellButton.currentTitleColor.cgColor
        cellButton.layer.cornerRadius = 7
        cellButton.setTitleColor(cellButton.currentTitleColor, for: .application)
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)])
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
