//
//  MPMoviePlayViewController.swift
//  Swift-Voice-Demo
//
//  Created by 非整勿扰 on 16/11/29.
//  Copyright © 2016年 iHTCboy. All rights reserved.
//

import UIKit
import MediaPlayer

class MPMoviePlayViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!

    var moviePlayerVC: MPMoviePlayerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(mediaPlayerPlaybackStateChange), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayerVC.moviePlayer)
        NotificationCenter.default.addObserver(self, selector: #selector(mediaPlayerPlaybackFinished), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayerVC.moviePlayer)
    }
    
    func mediaPlayerPlaybackStateChange(notification: Notification) {
        
    }
    
    func mediaPlayerPlaybackFinished(notification: Notification) {
        
    }

    @IBAction func PlayLocalMp4(_ sender: UIButton) {
        moviePlayerVC = nil;
        moviePlayerVC = MPMoviePlayerViewController.init(contentURL: URL.init(fileURLWithPath: Bundle.main.path(forResource: "T-ara-小苹果.mp4", ofType: nil)!))
        presentMoviePlayerViewControllerAnimated(moviePlayerVC)
    }
    
    @IBAction func playMovieWithURL(_ sender: UIButton) {
        if urlField.text == nil {
            print("url empty!")
            return
        }
        
        moviePlayerVC = nil;
        moviePlayerVC = MPMoviePlayerViewController.init(contentURL: URL.init(string: urlField.text!))
        presentMoviePlayerViewControllerAnimated(moviePlayerVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
