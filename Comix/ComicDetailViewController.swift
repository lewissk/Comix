//
//  ComicDetailViewController.swift
//  Comix
//
//  Created by Scott Lewis on 4/4/22.
//

import UIKit

class ComicDetailViewController: UIViewController {
    
    var comic: MarvelComicResult?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = comic?.title
        
        if let url = comic?.thumbnail.imageURL(size: .portraitIncredible) {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                imageView.image = image
            }
            catch {
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
