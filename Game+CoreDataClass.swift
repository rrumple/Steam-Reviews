//
//  Game+CoreDataClass.swift
//  Steam Reviews
//
//  Created by Randall Rumple on 11/17/19.
//  Copyright © 2019 RG. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Game)
public class Game: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called")
    }
}
