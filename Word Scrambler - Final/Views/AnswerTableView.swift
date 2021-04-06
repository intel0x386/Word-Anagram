//
//  AnswerTableView.swift
//  Word Scrambler - Final
//
//  Created by Ankit Shah on 2/26/21.
//

import UIKit

class AnswerTableView: UITableView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellW99", for: indexPath)
        return cell
    }
    

    func doSetup() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardFrameChanged(_ notification: Notification) {
        print("keyboard frame changed")
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = .zero
            scrollIndicatorInsets = .zero
        } else {
            // Not sur if superView will ever be nil for older iphones,
            // Hence, the bad code.
            var safeAreaBottomInset = CGFloat.zero
            
            if let safeAreaBI = self.superview?.safeAreaInsets.bottom {
                safeAreaBottomInset = safeAreaBI
            }
            
            let keyboardRect = keyboardFrame.cgRectValue
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height - safeAreaBottomInset, right: 0)
            scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height - safeAreaBottomInset, right: 0)
        }
    }
}
