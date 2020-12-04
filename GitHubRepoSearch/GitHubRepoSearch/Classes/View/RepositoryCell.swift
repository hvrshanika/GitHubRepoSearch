//
//  RepositoryCell.swift
//  GitHubRepoSearch
//
//  Created by Shanika Vithanage on 12/3/20.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    
    static let reuseID = "RepositoryCell"
    
    @IBOutlet weak var lblRepoName: UILabel!
    @IBOutlet weak var lblRepoOwner: UILabel!
    @IBOutlet weak var lblRepoSize: UILabel!
    @IBOutlet weak var lblEstDownTime: UILabel!
    
}
