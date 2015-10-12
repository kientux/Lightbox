import UIKit

extension LightboxController: UICollectionViewDataSource {

  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cellIdentifier = LightboxViewCell.reuseIdentifier
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier,
      forIndexPath: indexPath) as! LightboxViewCell
    let image: AnyObject = images[indexPath.row]
    let config = LightboxConfig.sharedInstance.config

    cell.parentViewController = self
    cell.loadingIndicator.alpha = 0
    cell.setupTransitionManager()

    if let imageString = image as? String {
      if let imageURL = NSURL(string: imageString) where config.remoteImages {
        cell.loadingIndicator.alpha = 1
        config.loadImage(
          imageView: cell.lightboxView.imageView, URL: imageURL) { error in
            if error == nil {
              cell.loadingIndicator.alpha = 0
              cell.lightboxView.updateViewLayout()
            }
        }
      } else {
        cell.lightboxView.imageView.image = UIImage(named: imageString)
        cell.lightboxView.updateViewLayout()
      }
    } else if let image = image as? UIImage {
      cell.lightboxView.imageView.image = image
      cell.lightboxView.updateViewLayout()
    }

    return cell
  }
}
