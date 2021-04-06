//
//  ViewController.swift
//  Word Scrambler - Final
//
//  Created by Ankit Shah on 2/26/21.
//

import UIKit

class ViewController: UIViewController, GameClassDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {


    @IBOutlet var answerTextField: AnswerTextField!
    @IBOutlet var displayLabel: DisplayLabel!
    @IBOutlet var answerTableView: AnswerTableView!
    var gameInstance: GameClass!
    var totalCorrect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up Label's Font and Color
        
        displayLabel.doSetup()
        answerTextField.doSetup()
        answerTableView.doSetup()
        answerTableView.dataSource = self

        
        gameInstance = GameClass.standard
        gameInstance.delegate = self
        gameInstance.startNewGame()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startNewGame))
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureDetected)))
        
    }
    
    
    
    // MARK: VIEW CONTROLLER SETUP
    @objc func tapGestureDetected() {
        answerTextField.resignFirstResponder()
    }
    
    @objc func startNewGame() {
        gameInstance.startNewGame()
        answerTextField.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        answerTextField.becomeFirstResponder()
    }
    
    func GameStarted(game: GameClass) {
        displayLabel.setAttributedText(text: gameInstance.mainWord)
        
        if displayLabel.attributedText?.size().width ?? 0.0 >= displayLabel.frame.width {
            print("The Word is bigger than the size of label")
            print("Starting a new game: \(displayLabel.attributedText?.size().width ?? 0.0) \(displayLabel.frame.width)")
            startNewGame()
        }
        
        answerTableView.reloadData()
        totalCorrect = 0
    }
    
    func GameEnded(game: GameClass) {
        
    }
    
    // MARK: GAME STATE CHANGES
    func GameFlagChangedFor(game: GameClass, index: Int) {
        
        answerTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func GameCorrectlyAnsweredAtIndex(game: GameClass, index: Int) {
        
        answerTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
        
        if gameInstance.didGameFinish() {
            gameInstance.startNewGame()
        }
        
    }

    
    // MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        gameInstance.subWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellW99", for: indexPath)
        
        if let answerCell = cell as? AnswerTableViewCell {
            
            
            let attributes: [NSAttributedString.Key: Any] = [
                .kern: 5,
            ]
            
            let text = gameInstance.maskedWord(for: indexPath.row)
            let attrText = NSAttributedString(string: text, attributes: attributes)
            answerCell.cellLabel.attributedText = attrText
            answerCell.cellButton.tag = indexPath.row
            answerCell.cellButton.setTitle(gameInstance.getButtonTitle(for: indexPath.row), for: .normal)
            
            if gameInstance.subFlags[indexPath.row] == .notMasked {
                answerCell.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.2)
            } else {
                answerCell.backgroundColor = UIColor.white
            }
            
            return answerCell
        }
        
        return cell
    }
    
    
    @IBAction func hintPressed(_ sender: UIButton) {
        
        if sender.currentTitle == "HINT" {
            gameInstance.changeFlagFor(index: sender.tag, to: .partiallyMasked)
        } else if sender.currentTitle == "WEB" {
            //gameInstance.changeFlagFor(index: sender.tag, to: .notMasked)
            let (word,_) = gameInstance[sender.tag]
            if let popVC = storyboard?.instantiateViewController(identifier: "WebVCSID") as? WebViewController {
                
                popVC.word = word
                popVC.maskedWord = gameInstance.maskedWord(for: sender.tag)
                
                popVC.modalPresentationStyle = .popover
                if let popOver = popVC.popoverPresentationController {
                    popOver.sourceView = sender
                    popOver.sourceRect = sender.bounds
                    popOver.delegate = self
                }
                present(popVC, animated: true, completion: nil)
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}

