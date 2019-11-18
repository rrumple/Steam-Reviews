//
//  Game+CoreDataProperties.swift
//  Steam Reviews
//
//  Created by Randall Rumple on 11/17/19.
//  Copyright © 2019 RG. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var name: String
    @NSManaged public var appid: Int64
    @NSManaged public var review: Review

}
