//
//  Observer.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 2/8/18.
//  Copyright © 2018 com.example. All rights reserved.
//

import UIKit
import AVKit

class Observer: NSObject {
    
    var observedObject: Any
    
    init (_ observedObject: Any) {
        self.observedObject = observedObject
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        if let postCell = observedObject as? Post_tvCell {
            if let avPlayer = object as? AVPlayer {
                switch keyPath {
                case Keys.kRateKeyPath:
                    if (avPlayer.rate > 0) {
                        postCell.loadingMediaActivityIndicator.stopAnimating()
                    }
                default:
                    break
                }
            }
        }

        
        
        
    }
    
}
