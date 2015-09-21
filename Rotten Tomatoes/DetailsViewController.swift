//
//  DetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Yuichi Kuroda on 9/16/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit
import Alamofire

class DetailsViewController: UIViewController {
    @IBOutlet weak var detailsText: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        navigationItem.title = movie.title
        
        scrollView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        
        titleLabel.text = movie.title
        detailsText.text = movie.synopsis
     
        detailsImage.layer.masksToBounds = true
        detailsImage.contentMode = UIViewContentMode.ScaleAspectFill
        
        if let image = movie.standardImage {
            detailsImage.image = image
        }
        else if let image = movie.thumbnailImage {
            detailsImage.image = image
            
            Alamofire.request(.GET, movie.standardImageUrl).response() { (_, response, data, error) -> Void in
                if let data = data {
                    self.detailsImage.image = UIImage(data: data)
                    self.movie.standardImage = UIImage(data: data)
                }
            }
        }
    }
    
}
