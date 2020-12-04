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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSavedData()
        prepareViewModelObserver()
        fetchRepoList()
    }
    
    func fetchRepoList() {
        viewModel.fetchRepoList(for: "tetris")
    }

    func prepareViewModelObserver() {
        self.viewModel.repositoriesDidChange = { (finished, error) in
            if !error {
                self.loadSavedData()
            }
        }
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
            print("Fetch failed")
        }
    }
}

// MARK: - Fetched Result Controller
extension RepoListViewController: NSFetchedResultsControllerDelegate {
    
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
    
    func collectionView(_ collectionView: UICollectionView,
           layout collectionViewLayout: UICollectionViewLayout,
           sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate width of the cell according to the collectionview width
        // So that number of columns is consistent across all devices
        let width = (collectionView.frame.size.width - 20) / 2
        
        return CGSize(width: width, height: 128)
    }
    
}

