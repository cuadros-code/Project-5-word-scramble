//
//  ViewController.swift
//  Project-5-word-scramble
//
//  Created by Kevin Cuadros on 7/08/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Actions NavigationBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, 
            target: self,
            action: #selector(startGame)
        )
        
        // Get List of Words From Disk
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } 
        
        if allWords.isEmpty {
            allWords = ["solkworm"]
        }
        
        startGame()
        
    }
    
    @objc func startGame() {
        self.title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = usedWords[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    // Show Alert to User Enter Word
    @objc func promptForAnswer(){
        let ac = UIAlertController(
            title: "Enter answer",
            message: nil,
            preferredStyle: .alert
        )
        ac.addTextField { (textField) in
            textField.placeholder = "Enter your word"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { 
            [weak ac, weak self] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    // Validate Every Possibles Error And Insert Word in Table
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer){
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer.lowercased(), at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .fade)
                    return
                } else {
                    showAlertController(
                        title: "Word not recognised",
                        message: "You can't just make them up, you know!"
                    )
                }
            } else {
                showAlertController(
                    title: "Word used already",
                    message: "Be more original!"
                )
            }
        } else {
            guard let title = title?.lowercased() else { return }
            showAlertController(
                title: "Word not possible",
                message: "You can't spell that word from \(title)"
            )
        }
    }
    
    // Validate if Can Build a New Word
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        if tempWord == word.lowercased() {
            return false
        }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    // Validate if Word not Exist in Array
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    // Validate if Word is Real and Exist
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en"
        )
        if word.utf16.count < 3 {
            return false
        }
        
        return misspelledRange.location == NSNotFound
    }
    
    func showAlertController(title: String, message: String){
        let ac = UIAlertController(
            title: title, 
            message: message,
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }


}

