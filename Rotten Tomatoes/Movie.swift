//
//  Movie.swift
//  Rotten Tomatoes
//
//  Created by Yuichi Kuroda on 9/15/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import Foundation

class Movie {
    var title: String = ""
    var synopsis: String = ""
    var thumbnailImageUrl: String = ""
    var standardImageUrl: String = ""
    var thumbnailImage: UIImage?
    var standardImage: UIImage?
    
    init(_ movie: [String : AnyObject]) {
        if let value = movie["title"] as? String {
            title = value
        }
        if let value = movie["synopsis"] as? String {
            synopsis = value
        }
        if let value = movie["posters"] as? [String : String] {
            if let value = value["thumbnail"] {
                thumbnailImageUrl = value
                
                if let range = thumbnailImageUrl.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch) {
                    standardImageUrl = thumbnailImageUrl.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
                }
            }
        }
    }
}