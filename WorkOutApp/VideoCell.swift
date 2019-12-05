//
//  VideoCell.swift
//  WorkOutApp
//
//  Created by I CHIEN LAI on 2019/11/27.
//  Copyright © 2019 I CHIEN LAI. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {


    @IBOutlet weak var videoimageView: UIImageView!
    @IBOutlet weak var videoTitleLable: UILabel!
    
    func setVideo(video: Video) {
        videoimageView.image = video.image
        videoTitleLable.text = video.title
    }
}
