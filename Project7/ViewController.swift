//
//  ViewController.swift
//  Project7
//
//  Created by İstemihan Çelik on 20.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Challenge:1 Project: 7
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain,target: self, action: #selector(shareTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(filterData))
        
        
        
        
        let urlString: String
            
        if navigationController?.tabBarItem.tag ==  0 {
            urlString =  "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
            
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                //we are ok to parse
                parse(json: data)
            } else {
                showError()
            }
        } else {
                showError()
            }
        
    }
    //Let user to use filter, in case of no filter word provided, it will show the non-filtered version.
    @objc func filterData(){
        let ac = UIAlertController(title: "Search", message: "Enter string", preferredStyle: .alert)
        ac.addTextField()
        
        let submitString = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac]  action in
            guard let answer = ac?.textFields?[0].text else {return }
            self?.submit(answer)
            //self?.tableView.reloadData()
            
        }
        ac.addAction(submitString)
        present(ac, animated: true)

    }
    func submit(_ answer: String){
        //To refresh filter
        filteredPetitions.removeAll(keepingCapacity: true)
        
        let word = answer.lowercased()
        
        //If there is no filter word, word is an empty string and filteredPetitions array is assigned to our default petitions array
        if word == "" {
            filteredPetitions = petitions
            title = "Petitions"

        }
            else {
                //If petition's title or body matched with the word, this petition added the filteredPetitions array
                for petition in petitions {
                    if petition.title.lowercased().contains(word) || petition.body.lowercased().contains(word){
                        filteredPetitions.append(petition)
                }
            }
                title = "Filter: \(word)"

        }
        tableView.reloadData()
    }
    
    //Challenge:1 Project: 7
    @objc func shareTapped(){
        let ac = UIAlertController(title: "Credits", message: "This info is provided by WhiteHouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem laoding a feed, please check your connection, try again!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
            let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            //FilterData called
            filterData()
            tableView.reloadData()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

