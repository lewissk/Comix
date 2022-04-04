//
//  ComicImageCollectionViewCollectionViewCell.swift
//  Comix
//
//  Created by Scott Lewis on 4/2/22.
//

import UIKit

class ComicImageCollectionViewCollectionViewCell: UICollectionViewCell {
    
    var comic: MarvelComicResult?
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    public func setComic(comic: MarvelComicResult) {
        self.comic = comic
        textLabel.text = comic.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = ""
        self.imageView.image = nil
    }
    
    
    
}
