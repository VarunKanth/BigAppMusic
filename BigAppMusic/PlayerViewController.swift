//
//  PlayerViewController.swift
//  BigAppMusic
//
//  Created by MacBook on 22/03/18.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {

    @IBOutlet weak var albumLabel: UILabel!
    
    @IBOutlet weak var albumArt: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var trackLength: UILabel!
    
    @IBOutlet weak var currDuration: UILabel!
    
    @IBOutlet weak var sliderSeek: UISlider!
    
    @IBOutlet weak var navItem : UINavigationItem!
    
    
    
    var timeElapsed : TimeInterval!
    var mpPlayer = MPMusicPlayerController()
    let cv = MPMediaQuery.songs()
    var songIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired(_:)), userInfo: nil, repeats: true)
        timer.tolerance = 0.1
        cv.groupingType = MPMediaGrouping.title
        mpPlayer.setQueue(with: cv)
        mpPlayer.nowPlayingItem = cv.items?[songIndex!]
        mpPlayer.play()
        loadButtons()
        loadAlbumDetails()
        mpPlayer.didChangeValue(forKey: (mpPlayer.nowPlayingItem?.title)!)
        mpPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTrackInfo), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        navItem.title = "Now Playing"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadButtons(){
        nextButton.setImage(UIImage(named:"forward"), for: .normal)
        previousButton.setImage(UIImage(named: "backward"), for: .normal)
        playPauseButton.setImage(UIImage(named: "pause-32"), for: .normal)
        sliderSeek.maximumValue = Float(mpPlayer.nowPlayingItem!.playbackDuration)
        sliderSeek.isContinuous = true
    }
    
    func loadAlbumDetails(){
        if let trackName = mpPlayer.nowPlayingItem?.title{
            albumLabel.text = trackName
        }
        if let trackImage = mpPlayer.nowPlayingItem?.artwork {
            albumArt.image = trackImage.image(at: albumArt.bounds.size)
        }
        else{
            albumArt.image = UIImage(named: "defaultArt")
        }
        setMaxDuration()
    }
    
    func setMaxDuration(){
        let trackDuration = mpPlayer.nowPlayingItem?.playbackDuration
        let trackDurationMinutes = Int(trackDuration! / 60)
        let trackDurationSeconds = Int((trackDuration?.truncatingRemainder(dividingBy: 60))!)
        if trackDurationSeconds < 10 {
            trackLength.text = "\(trackDurationMinutes):0\(trackDurationSeconds)"
        } else {
            trackLength.text = "\(trackDurationMinutes):\(trackDurationSeconds)"
        }
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        if mpPlayer.playbackState == .playing {
            mpPlayer.pause()
            sender.setImage(UIImage(named: "play-32"), for: .normal)
        }
        else{
            mpPlayer.play()
            sender.setImage(UIImage(named: "pause-32"), for: .normal)
        }
    } 
    
    @IBAction func nextSong(_ sender: UIButton) {
        if mpPlayer.indexOfNowPlayingItem == ((cv.items?.count)! - 1) {
            mpPlayer.skipToNextItem()
            mpPlayer.play()
        }
        else{
        mpPlayer.skipToNextItem()
    }
    }
    
    @IBAction func previousSong(_ sender: UIButton) {
        mpPlayer.skipToPreviousItem()
    }
    
    @objc func timerFired(_:AnyObject){
        timeElapsed = mpPlayer.currentPlaybackTime
        let trackDuration = mpPlayer.currentPlaybackTime
        let trackDurationMinutes = Int(trackDuration / 60)
        let trackDurationSeconds = Int(trackDuration.truncatingRemainder(dividingBy: 60))
        if trackDurationSeconds < 10 {
            currDuration.text = "\(trackDurationMinutes):0\(trackDurationSeconds)"
        } else {
            currDuration.text = "\(trackDurationMinutes):\(trackDurationSeconds)"
        }
        sliderSeek.value = Float(timeElapsed)
    }
    
    @objc func updateTrackInfo(){
        loadAlbumDetails()
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        sender.isContinuous = true
        mpPlayer.currentPlaybackTime = TimeInterval(sender.value)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
