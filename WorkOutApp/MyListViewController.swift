//
//  MyListViewController.swift
//  WorkOutApp
//
//  Created by Kao Pei-Wei on 2019/12/23.
//  Copyright © 2019 I CHIEN LAI. All rights reserved.
//

import UIKit
import AVKit

class MyList: NSObject {
    public static var listVideos: [Video]     = []
}

class MyListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension MyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyList.listVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let video = MyList.listVideos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListVideoCell") as! ListVideoCell
        
        cell.setVideo(video: video)
        if (indexPath.row == 0){
            print(cell)
        }
        return cell
    }
    
    
}
