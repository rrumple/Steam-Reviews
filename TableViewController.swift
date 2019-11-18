//
//  TableViewController.swift
//  Steam Reviews
//
//  Created by Randall Rumple on 11/17/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var container: NSPersistentContainer!
    var gamePredicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<Game>!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
        
        container = NSPersistentContainer(name: "Game")
        
        container.loadPersistentStores { storeDescription, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                print("Unresolved error \(error)")
            }
            
        }
        
       // performSelector(inBackground: #selector(fetchGames), with: nil)
        
        
        loadSavedData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @objc func changeFilter() {
        let ac = UIAlertController(title: "Filter games...", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Start Search", style: .default) { [unowned self] _ in
            let gameTextField = ac.textFields![0] as UITextField
            self.gamePredicate = NSPredicate(format: "name CONTAINS[c] %@", gameTextField.text! )
        self.loadSavedData()
        })
        
        ac.addAction(UIAlertAction(title: "Show all Games", style: .default) {[unowned self] _ in
                  
                  self.gamePredicate = nil
                  self.loadSavedData()
                  
              })
        ac.addTextField(configurationHandler: { (textfield) in
            textfield.placeholder = "Enter Game Name"
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
             present(ac,animated: true)
        
    }
    
    @objc func fetchGames(){
        
        if let data = try? String(contentsOf:
            URL(string:"http://api.steampowered.com/ISteamApps/GetAppList/v2")!) {
            let jsonGames = JSON(parseJSON: data)
            
            let jsonGamesArray = jsonGames["applist"]["apps"].arrayValue
            
            print("Received \(jsonGamesArray.count) new Games")
            
            DispatchQueue.main.async {
                [unowned self] in
                for jsonGame in jsonGamesArray {
                    let game = Game(context: self.container.viewContext)
                    self.configure(game: game, usingJSON: jsonGame)
                    
                }
                
                self.saveContext()
                self.loadSavedData()
            }
        }
        
    }
    
    func configure(game: Game, usingJSON json: JSON) {
        
        game.appid = json["appid"].int64Value
        game.name = json["name"].stringValue
        
        
    }
    
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving \(error)")
            }
        }
        
    }
    
    
    func loadSavedData() {
        
        if fetchedResultsController == nil {
            let request = Game.createFetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = gamePredicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game", for: indexPath)

        let game = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = game.name
        cell.detailTextLabel!.text = String(game.appid)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Reviews") as? ReviewTableViewController {
            vc.app = fetchedResultsController.object(at: indexPath)
            vc.container = self.container
            
            navigationController?.pushViewController(vc, animated: true)
        }
    
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
