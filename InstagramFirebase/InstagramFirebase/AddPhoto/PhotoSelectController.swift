//
//  PhotoSelectController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/30/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController {

  let cellId = "cellId"
  let headerId = "headerId"

  var images = [UIImage]()
  var selectedImage: UIImage?
  var assets = [PHAsset]()

  var header: PhotoSelectorHeader?

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .white

    setupNavigationButtons()

    collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)

    fetchPhotos()
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  fileprivate func setupNavigationButtons() {
    navigationController?.navigationBar.tintColor = .black
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
  }

  // MARK: - Handles

  @objc func handleCancel() {
    dismiss(animated: true, completion: nil)
  }

  @objc func handleNext() {
    let sharePhotoController = SharePhotoController()
    sharePhotoController.selectedImage = header?.photoImageView.image
    navigationController?.pushViewController(sharePhotoController, animated: true)
  }

  // MARK: - Fetch Photos
  fileprivate func fetchPhotos() {
    let fetchOptions = assetsFetchOptions()
    let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)

    DispatchQueue.global(qos: .background).async {
      allPhotos.enumerateObjects({ (asset, count, _) in
        print(count)

        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 200, height: 200)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, _) in

          if let image = image {
            self.images.append(image)
            self.assets.append(asset)

            if self.selectedImage == nil {
              self.selectedImage = image
            }
          }

          if count == allPhotos.count - 1 {
            DispatchQueue.main.async {
              self.collectionView?.reloadData()
            }
          }

        })
      })
    }
  }

  fileprivate func assetsFetchOptions() -> PHFetchOptions {
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 30

    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]

    return fetchOptions
  }

}

// MARK: - CollectionView Data Source
extension PhotoSelectorController {

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.selectedImage = images[indexPath.item]
    self.collectionView?.reloadData()

    let indexPath = IndexPath(item: 0, section: 0)
    collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? PhotoSelectorHeader else { return UICollectionViewCell() }

    self.header = header

    header.photoImageView.image = selectedImage

    if let selectedImage = selectedImage {
      if let index = self.images.index(of: selectedImage) {
        let selectedAsset = self.assets[index]

        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 600, height: 600)
        imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, _) in

          header.photoImageView.image = image
        })
      }
    }

    return header
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotoSelectorCell else { return UICollectionViewCell() }

    cell.photoImageView.image = images[indexPath.item]

    return cell
  }
}

// MARK: - CollectionView Flow Layout
extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = view.frame.width
    return CGSize(width: width, height: width)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 3) / 4
    return CGSize(width: width, height: width)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
}
