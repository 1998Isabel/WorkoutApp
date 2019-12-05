//
//  ViewController.swift
//  WorkOutApp
//
//  Created by I CHIEN LAI on 2019/11/27.
//  Copyright © 2019 I CHIEN LAI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        videos = createArray()
        
    }
    
    func createArray() -> [Video] {
        var tempVideos: [Video] = []
        let video1 = Video(image: #imageLiteral(resourceName: "knee_tuck_crunches"), title: "knee tuck crunches")
        let video2 = Video(image: #imageLiteral(resourceName: "leg_pulls_facing_down"), title: "leg pulls facing down")
        let video3 = Video(image: #imageLiteral(resourceName: "leg_pulls_facing_up"), title: "leg pulls facing up")
        let video4 = Video(image: #imageLiteral(resourceName: "oblique_crunch"), title: "oblique crunch")
        let video5 = Video(image: #imageLiteral(resourceName: "russian_twists"), title: "russian twists")
        let video6 = Video(image: #imageLiteral(resourceName: "side_hip_raises"), title: "side hip raises")
        let video7 = Video(image: #imageLiteral(resourceName: "slip_kicks"), title: "slip kicks")
        let video8 = Video(image: #imageLiteral(resourceName: "toe_taps"), title: "toe taps")
        let video9 = Video(image: #imageLiteral(resourceName: "toes_touch_crunches"), title: "toes touch crunches")
        
        tempVideos.append(video1)
        tempVideos.append(video2)
        tempVideos.append(video3)
        tempVideos.append(video4)
        tempVideos.append(video5)
        tempVideos.append(video6)
        tempVideos.append(video7)
        tempVideos.append(video8)
        tempVideos.append(video9)
        
        return tempVideos
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        
        cell.setVideo(video: video)
        
        return cell
    }
}
