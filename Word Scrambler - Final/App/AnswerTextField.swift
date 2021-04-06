//
//  AnswerTextField.swift
//  Word Scrambler - Final
//
//  Created by Ankit Shah on 2/26/21.
//

import UIKit

class AnswerTextField: UITextField, UITextFieldDelegate, CAAnimationDelegate {

    func doSetup() {
        font = UIFont.systemFont(ofSize: 28)
        
//        layer.masksToBounds = false
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: -2, height: 2)
//        textAlignment = .center
//        becomeFirstResponder()
//        autocapitalizationType = .allCharacters
        delegate = self
    }
    
    func animateForIncorrectAnswer() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.1
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        layer.shadowColor = UIColor.red.cgColor
        
        layer.add(animation, forKey: "position")
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer.shadowColor = UIColor.gray.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if let index = GameClass.standard.subWords.firstIndex(of: text) {
                textField.text = ""
                GameClass.standard.changeFlagForFromTextField(index: index, to: .notMasked)
                
            }
            else {
                animateForIncorrectAnswer()
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        print("Range: \(range), String: \(string)")
        
        
        // Don't do anything if a character has been deleted.
        // Backspace or whatever.
        if string == "" {
            return true
        }
        
        if let text = textField.text {
            if let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: string)
                if GameClass.standard.isValid(word: updatedText.uppercased()) {
                    return true
                } else {
                    animateForIncorrectAnswer()
                    return false
                }
            }
        }
        return true
    }
}
