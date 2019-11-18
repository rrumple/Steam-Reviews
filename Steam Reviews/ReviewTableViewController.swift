//
//  ReviewTableViewController.swift
//  Steam Reviews
//
//  Created by Randall Rumple on 11/17/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import CoreData

class ReviewTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var app: Game?
    var container: NSPersistentContainer!
    var reviewPredicate: NSPredicate?
    var fetchedResultsController: NSFetchedResultsController<Review>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        performSelector(inBackground: #selector(fetchReviews), with: nil)
        
        
        loadSavedData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func fetchReviews(){
           
        let appID = String(self.app!.appid)
        
           if let data = try? String(contentsOf:
            URL(string:"https://store.steampowered.com/appreviews/\(appID)?json=1&filter=recent&review_type=positive&num_per_page=50")!) {
               let jsonReviews = JSON(parseJSON: data)
               
               let jsonReviewsArray = jsonReviews["reviews"].arrayValue
               
               print("Received \(jsonReviewsArray.count) new Reviews")
               
               DispatchQueue.main.async {
                   [unowned self] in
                   for jsonReview in jsonReviewsArray {
                       let review = Review(context: self.container.viewContext)
                       self.configure(review: review, usingJSON: jsonReview)
                       
                   }
                   
                   self.saveContext()
                   self.loadSavedData()
               }
           }
           
       }
       
       func configure(review: Review, usingJSON json: JSON) {
           
        review.appid = self.app!.appid
        review.author = json["author"]["steamid"].stringValue
        review.numberOfGamesOwned = json["author"]["num_games_owned"].int64Value
        review.playtimeForever = json["author"]["playtime_forever"].int64Value
        review.review = json["review"].stringValue
        review.createdTimestamp = Date(timeIntervalSince1970: json["timestamp_created"].doubleValue)
        review.reviewID = json["recommendationid"].int64Value
        review.voteScore = json["weighted_vote_score"].doubleValue
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
               let request = Review.createFetchRequest()
               let sort = NSSortDescriptor(key: "author", ascending: false)
               request.sortDescriptors = [sort]
               request.fetchBatchSize = 20
               
               fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
               
               fetchedResultsController.delegate = self
           }
           
        self.reviewPredicate = NSPredicate(format: "appid == \(self.app!.appid)")
        
           fetchedResultsController.fetchRequest.predicate = reviewPredicate
           
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
           let cell = tableView.dequeueReusableCell(withIdentifier: "Review", for: indexPath)

           let review = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = review.author
        cell.detailTextLabel!.text = review.createdTimestamp.description

           return cell
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewDetail") as? ReviewDetailViewController {
               vc.review = fetchedResultsController.object(at: indexPath)
               
               
               navigationController?.pushViewController(vc, animated: true)
           }
       
       }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
