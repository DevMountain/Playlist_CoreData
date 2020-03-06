//
//  PlaylistController.swift
//  Playlist
//
//  Created by James Pacheco on 5/4/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CoreData

class PlaylistController {
    
    // MARK: - Properties
    ///Our shared instance
    static let shared = PlaylistController()
    //Holds the results of our Fetch Request, very similar to our source of truth
    var fetchedResultsController: NSFetchedResultsController<Playlist>
    
    /**
     Initalizes an instance of the PlaylistController class to interact with Playlist objects using the singleton pattern

     When this class is initalized, an NSFetchedResultsController is initalized to be used with Task objects. The initalized NSFetchedResultsController is assigned to the TaskController's resultsController property, and then the resultsController calls the `performFetch()` method
     */
    init() {
        //creates request
        let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        // Add the Sort Descriptors to the request. Sort Descriptors allows us to determine how we want the data organized from the fetch request
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        // Initialize a NSfetchedResultsController using the Fetch Request we just created
        let resultsController: NSFetchedResultsController<Playlist> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        // Set the initized NSFRC to our property
        fetchedResultsController = resultsController


        do{ // do/catch will display an error if fetchedResultsController isn't working
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch. \(error.localizedDescription)")
        }
    }
    // MARK: - CRUD
    // Create
    /**
     Creates a Playlist object and calls the `saveToPersistentStore()` method to save it to persistent storage

     - Parameters:
        - name: String value to be passed into the Playlist initializer's name parameter
     */
    func add(playlistWithName name: String) {
        //Creating a playlist
        Playlist(name: name)
        //
        saveToPersistentStore()
    }
    
    // Delete
    /**
     Removes an existing Playlist object from the CoreDataStack context by calling the `delete()` method and then saves the context changes by calling `saveToPersistentStore()`

     - Parameters:
        - playlist: The Playlist to be removed from storage
     */
    func delete(playlist: Playlist) {
        CoreDataStack.context.delete(playlist)
        saveToPersistentStore()
    }
    
    // MARK: Persistence
    /**
     Saves the current CoreDataStack's context to persistent storage by calling the `save()` method
     */
    func saveToPersistentStore() {
        do{
            try CoreDataStack.context.save()
        } catch {
            print("There was as error in \(#function) :  \(error) \(error.localizedDescription)")
        }
    }
}
