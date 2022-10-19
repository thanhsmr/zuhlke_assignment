//
//  BreedsCollectionViewCell.swift
//  zuhlke_assignment
//

//

import UIKit

class BreedsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.gray.cgColor
        mainView.layer.cornerRadius = 10
    }

    func updateView(name: String, isSelected: Bool) {
        lbName.text = name
        mainView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white
    }
}
