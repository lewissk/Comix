#  Comic List

## Overview
This project uses the Marvel API to pull a list of comics and display their cover images.

## Considerations
### Architectural Choices
This application uses a UICollectionView as the main view and incorporates a background loading caching queue to allow for more performant scrolling and the UICollectionViewDataSourcePrefetching protocol to allow the application to fetch more data when the user is getting to the end of the list. The UICollectionView uses a custom UICollectionViewCell and a custom UICollectionViewLayout

### Things that need to change
 - The image caching needs to be improved so that it uses some disk caching instead of just using memory cache
 - The Secret key for the Marvel API needs to be moved to a server where it can be protected from use by others or divulged by people instecting the app
 - Make the app more useable by allowing searching and filtering
 - The detail view needs more content and functionality
 - Add accessibility
 - Add localized strings
 - Add Analytics

### Libraries Used
#### Internal
 - UIKit
 - CryptoKit
 
#### External
 - None
 
#### Blogs and other Documentation
 - [Creating a Collection View Inspired by Pinterest](http://www.shanirivers.com/blog/2018-08-05-creating-collection-view-pinterest/)
 - [How To Build Resizing Image In Navigation Bar With Large Title](https://www.uptech.team/blog/build-resizing-image-in-navigation-bar-with-large-title)
 - [Asynchronously Loading Images into Table and Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/asynchronously_loading_images_into_table_and_collection_views)
 

