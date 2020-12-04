//
//  RepositoryCell.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    
    static let reuseID = "RepositoryCell"
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoOwner: UILabel!
    @IBOutlet weak var repoSize: UILabel!
    
    
}
