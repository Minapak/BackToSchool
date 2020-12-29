//
//  VideoListCell.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit

class VideoListCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var resolution: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
