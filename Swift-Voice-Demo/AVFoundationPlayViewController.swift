//
//  AVFoundationPlayViewController.swift
//  Swift-Voice-Demo
//
//  Created by 非整勿扰 on 16/11/29.
//  Copyright © 2016年 iHTCboy. All rights reserved.
//

import UIKit
import AVFoundation

class AVFoundationPlayViewController: UIViewController {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timeProgress: UIProgressView!
    @IBOutlet weak var volumeLbl: UILabel!
    
    var timer: Timer!
    
    lazy var audioPlayer:AVAudioPlayer = {
        let path = Bundle.main.path(forResource: "石进 - 夜的钢琴曲三.mp3", ofType: nil)
        let url = URL.init(fileURLWithPath: path!)
        var audioPlayer: AVAudioPlayer = try! AVAudioPlayer.init(contentsOf: url)
        audioPlayer.numberOfLoops = 0
//        audioPlayer.prepareToPlay()
        return audioPlayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true) //设置后台播放模式
        } catch {
            
        }
        
        
        audioPlayer.delegate = self
    }


    @IBAction func clickedPlayBtn(_ sender: UIButton) {
        if !audioPlayer.isPlaying {
            sender.setTitle("pause", for: .normal)
            audioPlayer.play()
            
            timer = nil;
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(changedTimeValue), userInfo: nil, repeats: true)
            timer.fire()
        }else{
            sender.setTitle("play", for: .normal)
            audioPlayer.pause()
            
            timer.invalidate()
        }
    }
    
    func changedTimeValue() {
        print(audioPlayer.currentTime)
        timeLbl.text = String.init(format: "time: %0.2f", audioPlayer.currentTime)
        timeProgress.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }

    @IBAction func clickedStopBtn(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            
            timer.invalidate()
        }
    }
    
    
    @IBAction func sliderVolumeView(_ sender: UISlider) {
        audioPlayer.volume = sender.value
        volumeLbl.text = String.init(format: "volume: %0.2f", audioPlayer.volume)
    }
    
    deinit {
        if let timer = timer{
            timer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension AVFoundationPlayViewController : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
