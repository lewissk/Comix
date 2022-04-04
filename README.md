#  Comic List

## Overview
This project uses the Marvel API to pull a list of comics and display their cover images.

## Considerations
### Architectural Choices
This application uses a UICollectionView as the main view and incorporates a background loading caching queue to allow for more performant scrolling and the UICollectionViewDataSourcePrefetching protocol to allow the application to fetch more data when the user is getting to the end of the list.

### Libraries Used
#### Internal
 - UIKit
 - CryptoKit
 
#### External
 - None
 
 

