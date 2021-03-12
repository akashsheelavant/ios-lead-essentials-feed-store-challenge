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

extension CoreDataCache {
	var localFeed: [LocalFeedImage] {
		feed.compactMap { $0 as? CoreDataFeedImage }
			.map { LocalFeedImage(id: $0.id,
								  description: $0.imageDescription,
								  location: $0.location,
								  url: $0.url)
			}
	}
}
