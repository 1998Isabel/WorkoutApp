//
//  VideoCell.swift
//  WorkOutApp
//
//  Created by I CHIEN LAI on 2019/11/27.
//  Copyright © 2019 I CHIEN LAI. All rights reserved.
//

import UIKit

protocol VideoViewNew {
    func addVideo(index: Int)
}

class VideoCell: UITableViewCell {


    @IBOutlet weak var videoimageView: UIImageView!
    @IBOutlet weak var videoTitleLable: UILabel!
    
    var cellDelegate: VideoViewNew?
    var index: IndexPath?
    
    
    @IBAction func AddButton(_ sender: Any) {
        print(index?.row)
        cellDelegate?.addVideo(index: (index?.row)!)
        print(MyList.listVideos.count)
    }
    
    func setVideo(video: Video) {
        videoimageView.image = video.image
        videoTitleLable.text = video.title
    }
}
