//
//  ListVideoCell.swift
//  WorkOutApp
//
//  Created by Kao Pei-Wei on 2019/12/23.
//  Copyright © 2019 I CHIEN LAI. All rights reserved.
//

import UIKit

class ListVideoCell: UITableViewCell {
    @IBOutlet weak var listvideoimageView: UIImageView!
    
    @IBOutlet weak var listvideoTitleLable: UILabel!
    
    func setVideo(video: Video) {
        listvideoimageView.image = video.image
        listvideoTitleLable.text = video.title
    }
}
