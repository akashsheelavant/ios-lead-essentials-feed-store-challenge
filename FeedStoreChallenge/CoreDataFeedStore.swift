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
		
		let container = try NSPersistentContainer.load(modelName: "CoreDataFeedStoreModel",
													   url: storeURL,
													   in: Bundle(for: CoreDataFeedStore.self))
		context = container.newBackgroundContext()
	}
	
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		let context = self.context
		context.perform {
			do {
				try self.deleteCache()
				try context.save()
				completion(nil)
			} catch  {
				completion(error)
			}
		}
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		let context = self.context
		context.perform {
			do {
				try self.deleteCache()
				let cache = CoreDataCache(context: context)
				cache.timestamp = timestamp
				cache.feed = NSOrderedSet(array: feed.map { local in
					let feed = CoreDataFeedImage(context: context)
					feed.from(local)
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
				if let cache = try self.fetchCache() {
					completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
				} else {
					completion(.empty)
				}
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	private func fetchCache() throws -> CoreDataCache? {
		let request = NSFetchRequest<CoreDataCache>(entityName: "CoreDataCache")
		request.returnsObjectsAsFaults = false
		return try context.fetch(request).first
	}
	
	private func deleteCache() throws {
		if let cache = try fetchCache() {
			context.delete(cache)
		}
	}
}
