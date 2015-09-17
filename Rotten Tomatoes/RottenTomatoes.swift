//
//  RottenTomatoes
//  Rotten Tomatoes
//
//  Created by Yuichi Kuroda on 9/15/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import Foundation
import Alamofire

class RottenTomatoes {
    let moviesUrl = "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json"
    
    var movies: [Movie] = []
    var moviesListReady: (() -> ())?
    
    init() {
        
    }
    
    func fetchMovies(moviesListReady: (() -> ())) {
        self.moviesListReady = moviesListReady
        
        // In case we're refreshing
        movies = []
        
        Alamofire.request(.GET, moviesUrl).validate().responseJSON() { (request, response, result) -> Void in
            if let json = result.value as? [String : AnyObject] {
                if let moviesList = json["movies"] as? [AnyObject] {
                    for movie in moviesList {
                        self.movies.append(Movie(movie as! [String : AnyObject]))
                    }
                }
                
                if let callback = self.moviesListReady {
                    callback()
                }
            }
        }
    }
    
}