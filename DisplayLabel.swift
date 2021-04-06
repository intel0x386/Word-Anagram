//
//  DisplayLabel.swift
//  Word Scrambler - Final
//
//  Created by Ankit Shah on 2/26/21.
//

import UIKit

class DisplayLabel: UILabel {

    func doSetup() {
        font = UIFont.systemFont(ofSize: 40)
        
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setAttributedText(text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .kern: 5,
            .font: UIFont.systemFont(ofSize: 40)
        ]

        attributedText = NSAttributedString(string:text, attributes: attributes)
    }


}
