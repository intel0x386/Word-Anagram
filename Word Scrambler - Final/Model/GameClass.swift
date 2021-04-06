//
//  GameClass.swift
//  Word Scrambler - New
//
//  Created by Ankit Shah on 2/27/21.
//

import Foundation



protocol GameClassDelegate: AnyObject {
    func GameStarted(game: GameClass)
    func GameFlagChangedFor(game: GameClass, index: Int)
    func GameEnded(game: GameClass)
    func GameCorrectlyAnsweredAtIndex(game: GameClass, index: Int)
}



class GameClass {
    
    static var standard = GameClass()
    
    enum GameState {
        case start
        case end
        case update
    }
    
    enum WordState {
        case totallyMasked
        case partiallyMasked
        case notMasked
    }
    
    weak var delegate: GameClassDelegate?
    
    private var fileDB: [String]
    private var mainFile: String = "" {
        didSet {
            print("MainFile Set to \(mainFile)")
            generateWordDB()
        }
    }
    
    var mainWord: String  {
        get {
            return mainFile.removeExtension().uppercased()
        }
    }
    var subWords: [String] = []
    var subFlags: [WordState] = []
    
    
    func maskedWord(for index: Int) -> String
    {
        let localWord = subWords[index]
        switch subFlags[index] {
        case .partiallyMasked:
            let secondLast = localWord.index(before: localWord.endIndex)
            var tempWord = ""
            tempWord.append(String(localWord[localWord.startIndex...localWord.startIndex]))
            tempWord.append(Array<String>(repeating: "X", count: localWord.count-2).joined())
            tempWord.append(String(localWord[secondLast...secondLast]))

            return tempWord

        case .totallyMasked:
            return Array<String>(repeating: "X", count: localWord.count).joined()

        case .notMasked:
            return localWord
        }
    }
    
    
    init() {
        fileDB = []
        let path = Bundle.main.resourcePath!
        let def = FileManager.default
        if let files = try? def.contentsOfDirectory(atPath: path) {
            for file in files {
                if file.hasSuffix("defc") {
                    fileDB.append(file)
                }
            }
        }
        print("Total Files loaded: \(fileDB.count)")
        
    }
    
    func startNewGame() {
        if let randomFile = fileDB.randomElement() {
            mainFile = randomFile
        }
        delegate?.GameStarted(game: self)
    }
    
    func generateWordDB() {
        
        if let url = Bundle.main.url(forResource: mainFile, withExtension: nil) {
            if let stringData = try? String(contentsOf: url) {
                let wordArray = stringData.components(separatedBy: "\n")
                var capWordArray = wordArray.map{ $0.uppercased() }
                
                
                // Remove the word from its own array if it exists
                if let index = capWordArray.firstIndex(of: mainWord) {
                    capWordArray.remove(at: index)
                }
                
                subWords = capWordArray
                subFlags = Array<WordState>(repeating: .totallyMasked, count: subWords.count)
                
            }
            
            print("Total words for \(mainWord) = \(subWords.count)")
            print(subWords)
        }
    }
    
    subscript(index: Int) -> (word: String, flag: WordState) {
        return (subWords[index], subFlags[index])
    }
    
    func changeFlagFor(index: Int, to state: WordState) {
        subFlags[index] = state
        delegate?.GameFlagChangedFor(game: self, index: index)
    }
    
    func changeFlagForFromTextField(index: Int, to state: WordState) {
        changeFlagFor(index: index, to: state)
        delegate?.GameCorrectlyAnsweredAtIndex(game: self, index: index)
    }
    
    func getMainFileURL() -> URL? {
        if let url = Bundle.main.url(forResource: mainFile, withExtension: nil) {
            return url
        }
        return nil
    }
    
    func didGameFinish() -> Bool {
        for flag in subFlags {
            if flag != .notMasked {
                return false
            }
        }
        return true
    }
    
    func getButtonTitle(for index: Int) -> String {
        switch subFlags[index] {
        case .notMasked, .partiallyMasked:
            return "WEB"
        case .totallyMasked:
            return "HINT"
        }
    }
    
    func isValid(word: String) -> Bool {
        
        var main = mainWord
        
        for c in word {
//            print("Comparing \(c) and \(main)")
            if main.contains(c) {
                if let index = main.firstIndex(of: c) {
                    main.remove(at: index)
                }
            } else {
                return false
            }
        }
        return true
    }
    
    
}

extension String {
    func removeExtension() -> String {
        var temp = self.components(separatedBy: ".")
        temp.removeLast()
        return temp.joined()
    }
}
