//
//  CoreDataFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Akash Sheelavant - Vendor on 2/21/21.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataFeedStore: FeedStore {
	
	private let context: NSManagedObjectContext

	public init(storeURL: URL) throws {

		let modelName = "CoreDataFeedStoreModel"
		guard let modelUrl = Bundle(for: CoreDataFeedStore.self).url(forResource: modelName, withExtension: "momd"),
			  let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else { throw NSError() }

		let description = NSPersistentStoreDescription(url: storeURL)
		let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
		container.persistentStoreDescriptions = [description]

		var loadError: Swift.Error?
		container.loadPersistentStores { loadError = $1 }
		try loadError.map { throw $0 }

		context = container.newBackgroundContext()
	}


	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let context = self.context
		context.perform {
			do {
				try self.deleteCache()
				completion(nil)
			} catch  {
				completion(nil)
			}
		}
	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = self.context
		context.perform {
			do {
				
				try self.deleteCache()				
				let cache = CoreDataCache(context: context)
				cache.timeStamp = timestamp
				cache.feed = NSOrderedSet(array: feed.map { local in
					let feed = CoreDataFeedImage(context: context)
					feed.id = local.id
					feed.imageDescription = local.description
					feed.location = local.location
					feed.url = local.url
					return feed
				})
				try context.save()
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		let context = self.context
		context.perform {
			do {
				let request = NSFetchRequest<CoreDataCache>(entityName: CoreDataCache.entity().name!)
				request.returnsObjectsAsFaults = false
				if let cache = try context.fetch(request).first {
					let feed = cache.feed?.compactMap { $0 as? CoreDataFeedImage }
						.map { LocalFeedImage(id: $0.id!, description: $0.imageDescription, location: $0.location, url: $0.url!) }
					completion(.found(feed: feed!, timestamp: cache.timeStamp!))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	private func fetchCache() throws -> CoreDataCache? {
		let request = NSFetchRequest<CoreDataCache>(entityName: CoreDataCache.entity().name!)
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}
	
	private func deleteCache() throws {
		if let cache = try fetchCache() {
			context.delete(cache)
			try context.save()
		}
	}
}
