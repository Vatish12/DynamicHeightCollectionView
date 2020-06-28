//
//  ViewController.swift
//  DynamicHeightCV
//
//  Created by Vatish Sharma on 28/06/20.
//  Copyright © 2020 Hunt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedUserList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addUser() {
        selectedUserList.append("User \(selectedUserList.count)")
        collectionView.insertItems(at: [IndexPath(row: self.selectedUserList.count - 1, section: 0)])
        collectionView.layoutIfNeeded()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedUserList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let user = selectedUserList[indexPath.row]

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedUserCell.className, for: indexPath) as? SelectedUserCell {

            print("ViewController::Assigned user::\(indexPath.row)::\(user)")

            cell.setup(user: user) { [weak self] deletedUser in
                if let index = self?.selectedUserList.firstIndex(where: { $0 == deletedUser }) {
                    self?.selectedUserList.remove(at: index)
                    self?.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }
            }

            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let user = selectedUserList[indexPath.row]
        print("ViewController::willDisplay::\(indexPath.row)::\(user)")
    }
}


class DynamicHeightCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

class LeftAlignedCVFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
