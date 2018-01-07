//
//  Post_tvCell.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/29/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class Post_tvCell: UITableViewCell {

    @IBOutlet weak var _imageview: UIImageView!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var _subreddit: UILabel!
    
    var _image: UIImage?
    
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
        setPreview(post.getImage())
        setSubreddit(post.getSubreddit())
    }
    
    /** Sets the preview image and adjusts the cell height of a post. */
    func setPreview(_ image: UIImage?) {
        guard let image = image
            else {
                _imageview.image = nil
                aspectConstraint = NSLayoutConstraint(item: _imageview, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: _imageview, attribute: NSLayoutAttribute.height, multiplier: 0, constant: 0.0)
                return
        }
        let aspect = image.size.width / image.size.height
        
        aspectConstraint = NSLayoutConstraint(item: _imageview, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: _imageview, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
        
        _imageview.image = image
        
        _image = image
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
