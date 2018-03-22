//
//  mediaItemCell.swift
//  BigAppMusic
//
//  Created by MacBook on 22/03/18.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit

class mediaItemCell: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    
    @IBOutlet weak var albumThumb: UIImageView!
    
    @IBOutlet weak var durationTrack: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
