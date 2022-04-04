//
//  ComixCollectionViewLayout.swift
//  Comix
//
//  Created by Scott Lewis on 4/4/22.
//

import UIKit

protocol ComixCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForComicAtIndexPath indexPath: IndexPath) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, imageSizeForComicAtIndexPath indexPath: IndexPath) -> MarvelImageSize
}

class ComixCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: ComixCollectionViewLayoutDelegate?
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 0.0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        
        for column in 0..<numberOfColumns
        {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0)
        {
            let indexPath = IndexPath(item: item, section: 0)
            
            
            /* Perform frame calculation, width is the previously calculated cellWidth, with the padding between cells removed. You ask the delegate for the height of the photo and calculate the frame height based on this height and the predefined cellPaddingfor the top and bottom. You then combine this with the x and y offsets of the current column to create the insetFrame used by the attribute.
             */
            let photoHeight = delegate?.collectionView(collectionView, heightForComicAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight!
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Creates instance of UICollectionViewLayoutAttribues, sets its frame & appends attributes to cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Expand content height to account for frame of newly calculated item and advances yOffset for current column based on frame.
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            // Advance column so that next item will be placed in next column
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
