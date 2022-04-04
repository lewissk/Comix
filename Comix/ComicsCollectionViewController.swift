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
    private let imageView = UIImageView(image: UIImage(named: "Logo"))
    private let portraitRatio: CGFloat = (324/216)
    private let landscapeRatio: CGFloat = (324/216)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        collectionView.prefetchDataSource = self
        
        mrc.fetchComics { comicAPIResponse in
            self.results = comicAPIResponse
            self.comics = (comicAPIResponse?.data.results)!
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        showImage(false)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        showImage(true)
//    }
    
    /// Setup the UI
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true

        title = "Comics"
        
        if let layout = collectionView?.collectionViewLayout as? ComixCollectionViewLayout {
            layout.delegate = self
        }

        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
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
           let destination = segue.destination as? ComixDetailTableViewController,
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

extension ComicsCollectionViewController: ComixCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForComicAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        var height = size * landscapeRatio
        if getSize(indexPath) == .portraitXLarge {
            height = size * portraitRatio
        }
        return height
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, imageSizeForComicAtIndexPath indexPath: IndexPath) -> MarvelImageSize {
        return getSize(indexPath)
    }
}

extension ComicsCollectionViewController {
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = show ? 1.0 : 0.0
        }
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
}

extension ComicsCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if let maxPath = indexPaths.max(), let results = self.results {
            if maxPath.row > comics.count - 10 {
                mrc.fetchComics (offset: results.data.offset + results.data.count + 1, limit: LIMIT){ comicAPIResponse in
                    self.results = comicAPIResponse
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
            self.loadImage (comic: comics[indexPath.row], for: indexPath){ [weak self] (image) in
                guard let self = self, let image = image else { return }
                cell.imageView.image = image
                self.cache.setObject(image, forKey: itemNumber)
            }
        }
    }

    private func loadImage(comic: MarvelComicResult, for indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async { [self] in
            let imageSize = getSize(indexPath)
            if let url = comic.thumbnail.imageURL(size: imageSize) {
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
    
    private func getSize(_ indexPath: IndexPath) -> MarvelImageSize {
        if indexPath.row % 3 == 0 {
            return .landscapeLarge
        } else {
            return .portraitXLarge
        }
    }
}

private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

