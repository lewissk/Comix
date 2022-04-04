//
//  ViewController.swift
//  Comix
//
//  Created by Scott Lewis on 4/2/22.
//

import UIKit

class ComicsCollectionViewController: UICollectionViewController {
    
    private let COMIC_IMAGE_CV_CELL_IDENTIFIER = "ComicImageCollectionViewCell"
    private let DETAIL_SEGUE_IDENTIFER = "ShowDetail"
    private var results: MarvelComicResultsHeader?
    private var comics = [MarvelComicResult]()
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    private let mrc = MarvelRequestController()
    private let LIMIT = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.prefetchDataSource = self
        
        mrc.fetchComics { comicAPIResponse in
            self.results = comicAPIResponse
            self.comics = (comicAPIResponse?.data.results)!
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COMIC_IMAGE_CV_CELL_IDENTIFIER, for: indexPath) as! ComicImageCollectionViewCollectionViewCell
        cell.setComic(comic: comics[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DETAIL_SEGUE_IDENTIFER,
           let destination = segue.destination as? ComicDetailViewController,
           let makeIndex = collectionView.indexPathsForSelectedItems?.first {
            destination.comic = comics[makeIndex.item]
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}

extension ComicsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}

extension ComicsCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
        if let maxPath = indexPaths.max(), let results = self.results {
            if maxPath.row > comics.count - 10 {
                print("get more now, offset: \(results.data.offset) limit: \(results.data.limit)")
                mrc.fetchComics (offset: results.data.offset + results.data.count + 1, limit: LIMIT){ comicAPIResponse in
                    self.results = comicAPIResponse
                    print("comicAPIResponse offset: \(comicAPIResponse?.data.offset ?? 0), limit: \(comicAPIResponse?.data.limit ?? 0)")
                    guard let moreComics = comicAPIResponse?.data.results else { return }
                    self.comics.append(contentsOf: moreComics)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            
        }
    }
}

extension ComicsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ComicImageCollectionViewCollectionViewCell else { return }
        
        let item = self.comics[indexPath.item]
        let itemNumber = NSNumber(value: item.id)
        
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            cell.imageView.image = cachedImage
        } else {
            self.loadImage (comic: comics[indexPath.row]){ [weak self] (image) in
                guard let self = self, let image = image else { return }
                cell.imageView.image = image
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
    }

    private func loadImage(comic: MarvelComicResult, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            if let url = comic.thumbnail.imageURL(size: .standardLarge) {
                do {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

