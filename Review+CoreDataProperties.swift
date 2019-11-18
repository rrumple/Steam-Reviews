//
//  Review+CoreDataProperties.swift
//  Steam Reviews
//
//  Created by Randall Rumple on 11/17/19.
//  Copyright © 2019 RG. All rights reserved.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var author: String
    @NSManaged public var review: String
    @NSManaged public var voteScore: Double
    @NSManaged public var numberOfGamesOwned: Int64
    @NSManaged public var playtimeForever: Int64
    @NSManaged public var createdTimestamp: Date
    @NSManaged public var appid: Int64
    @NSManaged public var reviewID: Int64
    @NSManaged public var reviews: Game

}
