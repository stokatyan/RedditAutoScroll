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
    
    func setPreview(_ image: UIImage?) {
        if (image == nil) {
            _imageview.removeFromSuperview()
        } else {
            _imageview.image = image
        }
        
        
    }
    
    func setTitle(_ text: String) {
        _title.text = text
    }
    
}
