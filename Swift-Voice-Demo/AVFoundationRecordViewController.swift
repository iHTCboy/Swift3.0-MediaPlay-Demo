
//
//  AVFoundationRecordViewController.swift
//  Swift-Voice-Demo
//
//  Created by 非整勿扰 on 16/11/29.
//  Copyright © 2016年 iHTCboy. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class AVFoundationRecordViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    let audioFileName = "record.caf"
    var audioRecoder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        do {
            // 扬声器播放:AVAudioSessionCategoryPlayback  听筒:AVAudioSessionCategoryPlayAndRecord
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
            try audioRecoder = AVAudioRecorder.init(url: getSavePath(), settings: getAudioSettingDic())
            audioRecoder.isMeteringEnabled = true
            audioRecoder.prepareToRecord()
            audioRecoder?.delegate = self;
            
        } catch {
            print(" error")
        }
        
        print(getSavePath())
    }

    @IBAction func clickedRecordBtn(_ sender: UIButton) {
        if let audio = audioPlayer {
            audio.stop()
        }
        
        if !audioRecoder.isRecording {
            sender.setTitle("Pause", for: .normal)
            audioRecoder.record()
            timer = nil;
            timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(changeRecordPower), userInfo: nil, repeats: true)
        }else{
            sender.setTitle("Restore", for: .normal)
            audioRecoder.pause()
            timer.invalidate()
        }
    }

    @IBAction func clickedStopBtn(_ sender: UIButton) {
        audioRecoder.stop()
        timer.invalidate()
    }
    
    @IBAction func clickedPlayBtn(_ sender: UIButton) {
        if audioRecoder.isRecording {
            audioRecoder.stop()
        }
        
        if audioPlayer == nil{
            do {
                try audioPlayer = AVAudioPlayer.init(contentsOf: getSavePath());
                audioPlayer.numberOfLoops = 0
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
            } catch  {
                print("error play")
            }
        }
        
        if !audioPlayer.isPlaying {
            sender.setTitle("pause", for: .normal)
            audioPlayer.play()
        }else{
            sender.setTitle("play", for: .normal)
            audioPlayer.pause()
        }
    }
    
    func changeRecordPower() {
        // 更新测量值
        audioRecoder.updateMeters()
        // 取得第一个通道的音频，注意音频强度范围时-160到0
        let power = audioRecoder.averagePower(forChannel: 0)
        let progressValue = (1.0/160.0)*(power+160.0)
        progressView.setProgress(progressValue, animated: true)
        print("changingRecordPower",power, progressValue)
    }
    
    func getSavePath() -> URL {
        // used NSString method
        var audioPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: audioPath!) {
            print("no exist audivoFile")
        }
        audioPath = (audioPath! as NSString).appendingPathComponent(audioFileName)
        return URL.init(fileURLWithPath: audioPath!)
        
        // used URL method
//        let fileManager = FileManager.default
//        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = urls[0] as URL
//        let soundURL = documentDirectory.appendingPathComponent(audioFileName)
//        return soundURL
    }
    
    func getAudioSettingDic() -> Dictionary<String, Any> {
        var dicM = Dictionary<String, Any>.init()
        //设置录音格式
        dicM.updateValue(kAudioFormatLinearPCM, forKey: AVFormatIDKey)
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        dicM.updateValue(44000, forKey: AVSampleRateKey)
        //设置通道,这里采用单声道
        dicM.updateValue(1, forKey: AVNumberOfChannelsKey)
        //每个采样点位数,分为8、16、24、32
        dicM.updateValue(8, forKey: AVLinearPCMBitDepthKey)
        //是否使用浮点数采样
        dicM.updateValue(true, forKey: AVLinearPCMIsFloatKey)
        
        return dicM
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

extension AVFoundationRecordViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audioRecorderDidFinishRecording")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
    }
    
}
