//
//  AudioToolboxViewController.swift
//  Swift-Voice-Demo
//
//  Created by 非整勿扰 on 16/11/29.
//  Copyright © 2016年 iHTCboy. All rights reserved.
//

import UIKit
import AudioToolbox

class AudioToolboxViewController: UIViewController {

    @IBOutlet weak var alarmBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    
    var soundId: SystemSoundID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func clickedAlarmBtn(_ sender: Any) {
        playSoundEffect(name: "alarm.caf")
    }
    
    @IBAction func clickedErrorBtn(_ sender: Any) {
        playSoundEffect(name: "ct-error.caf")
    }
    
    @IBAction func clickedStopBtn(_ sender: Any) {
        AudioServicesRemoveSystemSoundCompletion(soundId)
    }
    
    func playSoundEffect(name: String) {
        let audioFile = Bundle.main.path(forResource: name, ofType: nil)
        
        assert(audioFile != nil, "voice path is nil")
        
        let fileUrl = URL.init(fileURLWithPath: audioFile!)
        
        AudioServicesCreateSystemSoundID(fileUrl as CFURL, &soundId)
        
        AudioServicesAddSystemSoundCompletion(soundId, nil, nil, {
            (soundID:SystemSoundID, _:UnsafeMutableRawPointer?) in
            print(" play audio completioned")
        }, nil)
        
        AudioServicesPlaySystemSound(soundId)
//        AudioServicesPlayAlertSound(soundId) //paly and Shake

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
