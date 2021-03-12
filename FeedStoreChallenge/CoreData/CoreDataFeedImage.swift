//
//  CoreDataFeedImage.swift
//  FeedStoreChallenge
//
//  Created by Akash Seelavant on 12/03/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import CoreData

class CoreDataFeedImage: NSManagedObject {
	@NSManaged var id: UUID
	@NSManaged var imageDescription: String?
	@NSManaged var location: String?
	@NSManaged var url: URL
	@NSManaged var cache: CoreDataCache
}
