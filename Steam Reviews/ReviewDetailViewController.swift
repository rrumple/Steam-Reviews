//
//  ReviewDetailViewController.swift
//  Steam Reviews
//
//  Created by Randall Rumple on 11/17/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController {

    @IBOutlet weak var steamIDLabel: UILabel!
    @IBOutlet weak var gamesOwnedLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var reviewTextview: UITextView!
    
    var review : Review?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        steamIDLabel.text = review?.author
        gamesOwnedLabel.text = String(review!.numberOfGamesOwned)
        playtimeLabel.text = String(review!.playtimeForever)
        scoreLabel.text = String(review!.voteScore)
        reviewTextview.text = review?.review
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
