//
//  CoreDataCache.swift
//  FeedStoreChallenge
//
//  Created by Akash Seelavant on 12/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

class CoreDataCache: NSManagedObject {
	@NSManaged var timestamp: Date
	@NSManaged var feed: NSOrderedSet
}
