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

	private let modelName = "CoreDataFeedStoreModel"
	private let context: NSManagedObjectContext

	public init(bundle: Bundle = .main) throws {

		guard let modelUrl = Bundle(for: CoreDataFeedStore.self).url(forResource: modelName, withExtension: "momd"),
			  let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else { throw NSError() }
		let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)

		var loadError: Swift.Error?
		container.loadPersistentStores { loadError = $1 }
		try loadError.map { throw $0 }

		context = container.newBackgroundContext()
	}


	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {

	}

	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {

	}

	public func retrieve(completion: @escaping RetrievalCompletion) {
		completion(.empty)
	}
}
