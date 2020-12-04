//
//  ViewController.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import UIKit
import CoreData

class RepoListViewController: UIViewController {
    
    let viewModel = RepoListViewModel()
    let coreDataManager = CoreDataManager.instance // Make sure CoreDataManager gets init in Main thread

    @IBOutlet weak var repoCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var fetchedResultsController: NSFetchedResultsController<Repository>!
    
    var isRefresing = true // Defaults to true because in the viewDidLoad we are calling the API
    var errorOccured = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitialUI()
    }
    
    func setInitialUI() {
        prepareViewModelObserver()
        loadSavedData() // Initialize FetchedResultsController
        
        searchBar.text = "tetris" // Set the default search query
        searchBarSearchButtonClicked(searchBar)
    }
    
    func prepareViewModelObserver() {
        self.viewModel.errorOccured = { (message) in
            self.isRefresing = false
            if !self.errorOccured {
                self.errorOccured = true
                self.show(error: message)
            }
        }
    }
    
    @objc func fetchRepoList(for query: String) {
        viewModel.fetchRepoList(for: query)
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Repository.createFetchRequest()
            
            // Sort using the custom defined sortOrder key
            let sort = NSSortDescriptor(key: "sortOrder", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 30

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataManager.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }

        do {
            try fetchedResultsController.performFetch()
            repoCollectionView.reloadData()
        } catch {
            show(error: NSLocalizedString("Error occured while retreiving data", comment: ""))
        }
    }
    
    func show(error message: String) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        })
        alert.addAction(ok)
        self.present(alert, animated: true) {() -> Void in }
    }
}

// MARK: - Fetched Result Controller
extension RepoListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        loadSavedData()
        isRefresing = false
        errorOccured = false
    }
    
}

// MARK: - Collection View
extension RepoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.reuseID, for: indexPath) as? RepositoryCell else {
            return UICollectionViewCell()
        }
        
        let repository = fetchedResultsController.object(at: indexPath)
        
        cell.repoName.text = repository.name
        cell.repoOwner.text = repository.owner?.login
        cell.repoSize.text = "\(repository.size) KB"
        
        cell.backgroundColor = repository.hasWiki ? .systemGroupedBackground : .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
           sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate width of the cell according to the collectionview width
        // So that number of columns is consistent across all devices
        let width = (collectionView.frame.size.width - 20) / 2
        
        return CGSize(width: width, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath.row == collectionView.numberOfItems(inSection: 0)-1 || errorOccured) && !isRefresing  {
            isRefresing = true;
            self.fetchRepoList(for: viewModel.searchQuery!)
        }
    }
    
}

// MARK: - Search bar delegate
extension RepoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, query != "" {
            viewModel.searchQuery = query
        }
        view.endEditing(true)
    }
    
}

