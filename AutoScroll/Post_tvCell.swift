//
//  Post_tvCell.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/29/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class Post_tvCell: UITableViewCell {
    
    @IBOutlet var _imageview: FLAnimatedImageView!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _subreddit: UILabel!
    
    var videoPlayer = AVPlayer()
    
    /** Sets the constraints of the cell to make the image being displayed fit perfectly on screen. */
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                _imageview.removeConstraint(oldValue!)
            }

            if aspectConstraint != nil {
                _imageview.addConstraint(aspectConstraint!)
            }
        }
    }

    // MARK: Preview Content Setup
    
    /**
     Displays the contents of a given reddit post.
     - parameter post: the reddit post to display */
    func displayContents(of post: RPost) {
        post.rPrint()
        
        removePreviewContent()
        setTitle(post.getTitle())
        setSubreddit(post.getSubreddit())
        
        if let previewImage = post.getPreviewImage() {
            setPreview(image: previewImage)
        } else if let previewGif = post.getPreviewGif() {
            setPreview(gif: previewGif)
        } else if let previewVideo = post.getPreviewVideo() {
            setPreview(video: previewVideo)
        }
    }
    
    /**
     Sets the imageView image to nil and removes all layers that contains videos.
     Since the cells are reaused, content that is added manualy must also be removed manualy. */
    func removePreviewContent() {
        setPreview(image: nil)
        
        if let layers = _imageview.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    /**
     Sets the preview as an image and adjusts the cell height of a post.
     If `nil` is passed then the cell is adjusted to not have space for the image. */
    func setPreview(image: UIImage?) {
        guard let image = image else {
            _imageview.image = nil
            setAspectRatio(0)
            return
        }
        
        let aspect = image.size.height / image.size.width
        setAspectRatio(aspect)
        
        _imageview.image = image
        _imageview.backgroundColor = UIColor.red
    }
    
    /** Sets the preview as a gif and adjusts the cell height of the post. */
    func setPreview(gif: FLAnimatedImage) {
        let aspect = gif.size.height / gif.size.width
        setAspectRatio(aspect)
        
        _imageview.animatedImage = gif
        _imageview.backgroundColor = UIColor.red
    }
    
    /** Sets the preview as a video, and adjusts the cell height of the post. */
    func setPreview(video: AVPlayer) {
        setAspectRatio(1.2)
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: video)
        
        layer.frame = _imageview.bounds
        _imageview.layer.addSublayer(layer)
        
        video.play()
    }
    
    /**
     Sets the aspect ration of the preview content.
     - parameter aspectRatio: `height/width` */
    func setAspectRatio(_ aspectRatio: CGFloat) {
        aspectConstraint = NSLayoutConstraint(item: _imageview,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: _imageview,
                                              attribute: NSLayoutAttribute.width,
                                              multiplier: aspectRatio, constant: 0.0)
    }
    
    // MARK: Text setup
    
    /** Sets the text of the title label. */
    func setTitle(_ text: String) {
        _title.text = text
    }
    
    /** Sets the text of the subreddit label. */
    func setSubreddit(_ text: String) {
        _subreddit.text = "r/" + text
    }
    
}
