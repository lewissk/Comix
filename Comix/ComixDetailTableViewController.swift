//
//  ComixDetailTableViewController.swift
//  Comix
//
//  Created by Scott Lewis on 4/4/22.
//

import UIKit

class ComixDetailTableViewController: UITableViewController {
    var comic: MarvelComicResult?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comic Detail"
        
        if let url = comic?.thumbnail.imageURL(size: .portraitIncredible) {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                imageView.image = image
                titleLabel.text = comic?.title
            }
            catch {
                print(error)
            }
        }
    }
    
    // Hide Headers and Footers
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
 
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

}
