//
//  DogTableViewCell.swift
//  zuhlke_assignment
//

//

import UIKit
import Kingfisher

class DogTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    var onLayoutNeedChange: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImage(url: String) {
        mainImage.kf.cancelDownloadTask()
        mainImage.kf.setImage(with: URL(string: url)) { _ in
            self.onLayoutNeedChange?()
        }
    }
    
}
