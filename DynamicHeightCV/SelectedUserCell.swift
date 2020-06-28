//
//  SelectedUserCell.swift
//  DynamicHeightCV
//
//  Created by Vatish Sharma on 28/06/20.
//  Copyright © 2020 Hunt. All rights reserved.
//

import UIKit

class SelectedUserCell: UICollectionViewCell {

    static var className: String = "SelectedUserCell"

    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    private var user: String! {
        didSet {
            initView()
        }
    }
    private var onDelete: ((String) -> ())!

    func setup(user: String, onDelete: @escaping (String) -> ()) {
        self.user = user
        self.onDelete = onDelete
    }

    func initView() {
        print("\(SelectedUserCell.className)::initView::\(String(describing: user))")
        nameButton.setTitle(user, for: .normal)
    }

    @IBAction func delete() {
        onDelete(user)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        print("\(SelectedUserCell.className)::awakeFromNib::\(String(describing: user == nil ? "" : user))")
    }

    override func prepareForReuse() {
        nameButton.setTitle("", for: .normal)
        super.prepareForReuse()
        print("\(SelectedUserCell.className)::prepareForReuse::\(String(describing: user))")
    }
}
