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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
        
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
    
    func startGame() {
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
    
    func submit(_ answer: String) {
        print(answer)
    }


}

