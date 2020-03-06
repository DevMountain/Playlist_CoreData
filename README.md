# Playlist Coredata - Converting FetchRequest to FetchResult
1. Remove the source of truth on the `PlaylistController`
2. Create a a property called `fetchedResultsController` of  type `NSFetchedResultsController<Playlist>`
`var fetchedResultsController: NSFetchedResultsController<Playlist>`
3. Create an initializer that Initializes an instance of the PlaylistController class to interact with Playlist objects using the singleton pattern
    * Note: Be sure to explain the code and walk through it with the students
```
init() {
    //creates request
    let request: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    // Add the Sort Descriptors to the request. Sort Descriptors allows us to determine how we want the data organized from the fetch request
    request.sortDescriptors = [NSSortDescriptor(key: “name”, ascending: true)]
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
```
4. On our `PlaylistListTableviewController` return `PlaylistController.shared.fetchedResultsController.sections?[section].numberOfObjects ?? 0` from `numberOfRowsInSection`
    * Note: Explain how the fetchResults is working
5. In our `cellForRowAt`  let our `playlist` equal `PlaylistController.shared.fetchedResultsController.object(at: indexPath)`
6. In our segue let our `playlist` equal `PlaylistController.shared.fetchedResultsController.object(at: index)`
7. Note that the app still won’t work properly even though we replaced our source of truth. This is becuase the table view wants to do stuff but our Fetch Results Controller is fighting it. To fix this issue add this code snippet at the bottom of our `PlaylistListTableViewController`
```
extension PlaylistListTableViewController: NSFetchedResultsControllerDelegate {
    // Conform to the NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
            case .delete:
                guard let indexPath = indexPath else { break }
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else { break }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { break }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                fatalError()
        }
    }
    //additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .move:
                break
            case .update:
                break
            @unknown default:
                fatalError()
        }
    }
}
```
8. In our `ViewDidLoad` set our `PlaylistController.shared.fetchedResultsController.delegate` equal to `self`
