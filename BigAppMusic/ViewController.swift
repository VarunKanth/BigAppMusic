//
//  ViewController.swift
//  BigAppMusic
//
//  Created by MacBook on 21/03/18.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class MusicLibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let mediaItems = MPMediaQuery.songs().items
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var mediaListTable: UITableView!
    
    var tDuration : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = "My Playlist"
        checkAuthorization()
        mediaListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func checkAuthorization() {
        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                print("Authorized")
            } else {
                self.requestAuthorization()
            }
        }
    }
    
    func requestAuthorization(){
        let error = "Not Authorized, Go to Settings"
        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        present(controller, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mediaItems?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mediaListTable.dequeueReusableCell(withIdentifier: "mediaItem", for: indexPath) as! mediaItemCell
        cell.songTitle.text = mediaItems![indexPath.row].title
        if let trackImage = mediaItems![indexPath.row].artwork {
            cell.albumThumb.image = trackImage.image(at: cell.albumThumb.bounds.size)
        }
        else{
            cell.albumThumb.image = UIImage(named: "defaultArt")
        }
        let trackDuration = mediaItems![indexPath.row].playbackDuration
        let trackDurationMinutes = Int(trackDuration / 60)
        let trackDurationSeconds = Int(trackDuration.truncatingRemainder(dividingBy: 60))
        if trackDurationSeconds < 10 {
            tDuration = "\(trackDurationMinutes):0\(trackDurationSeconds)"
        } else {
            tDuration = "\(trackDurationMinutes):\(trackDurationSeconds)"
        }
        cell.durationTrack.text = tDuration!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mediaPlayer")
        if let vc = vc as? PlayerViewController{
        vc.songIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.mediaListTable.indexPathForSelectedRow{
            mediaListTable.deselectRow(at: index, animated: false)
        }
    }
    
}

