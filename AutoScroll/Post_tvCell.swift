//
//  Post_tvCell.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/29/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class Post_tvCell: UITableViewCell {
    
    @IBOutlet var _imageview: FLAnimatedImageView!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _subreddit: UILabel!
    
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

    /**
     Displays the contents of a given reddit post.
     - parameter post: the reddit post to display */
    func displayContents(of post: RPost) {
        setTitle(post.getTitle())
        setSubreddit(post.getSubreddit())
        let sub = post.getSubreddit()
        
        if let previewImage = post.getPreviewImage() {
            setPreview(image: previewImage)
        } else if let previewGif = post.getPreviewGif() {
            setPreview(gif: previewGif)
        } else {
            setPreview(image: nil)
        }
    }
    
    /**
     Sets the preview as an image and adjusts the cell height of a post.
     If `nil` is passed then the cell is adjusted to not have space for the image. */
    func setPreview(image: UIImage?) {
        guard let image = image else {
            _imageview.image = nil
                
            aspectConstraint = NSLayoutConstraint(item: _imageview,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.lessThanOrEqual,
                                                  toItem: _imageview,
                                                  attribute: NSLayoutAttribute.width,
                                                  multiplier: 0, constant: 0.0)
            return
        }
        
        let aspect = image.size.height / image.size.width

        aspectConstraint = NSLayoutConstraint(item: _imageview,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: _imageview,
                                              attribute: NSLayoutAttribute.width,
                                              multiplier: aspect, constant: 0.0)
        
        _imageview.image = image
        _imageview.backgroundColor = UIColor.red
    }
    
    /** Sets the preview as a gif and adjusts the cell height of a post. */
    func setPreview(gif: FLAnimatedImage) {
        let aspect = gif.size.height / gif.size.width
        
        aspectConstraint = NSLayoutConstraint(item: _imageview,
                                              attribute: NSLayoutAttribute.height,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: _imageview,
                                              attribute: NSLayoutAttribute.width,
                                              multiplier: aspect, constant: 0.0)
        
        _imageview.animatedImage = gif
        _imageview.backgroundColor = UIColor.red
    }
    
    /** Sets the text of the title label. */
    func setTitle(_ text: String) {
        _title.text = text
    }
    
    /** Sets the text of the subreddit label. */
    func setSubreddit(_ text: String) {
        _subreddit.text = "r/" + text
    }
    
}
