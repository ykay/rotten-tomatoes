//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Yuichi Kuroda on 9/14/15.
//  Copyright © 2015 Yuichi Kuroda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var movieListTableView: UITableView!

    var refreshControl: UIRefreshControl!
    var selectedRow: Int = 0
    
    let rt: RottenTomatoes = RottenTomatoes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        movieListTableView.insertSubview(refreshControl, atIndex: 0)
        
        fetchMovies()
    }

    func fetchMovies() {
        rt.fetchMovies( {
            self.movieListTableView.reloadData()
        } )
    }
    
    func onRefresh() {
        fetchMovies()
        
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rt.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.yk.codepath.ListCell") as! ListCell
        
        if rt.movies.count > indexPath.row {
            cell.titleLabel.text = rt.movies[indexPath.row].title
            cell.synopsisLabel.text = rt.movies[indexPath.row].synopsis
            cell.thumbImageView?.layer.masksToBounds = true
            cell.thumbImageView?.layer.cornerRadius = 4.0
            cell.thumbImageView?.contentMode = UIViewContentMode.ScaleAspectFill
            
            if let url = NSURL(string: rt.movies[indexPath.row].thumbnailImageUrl) {
                let request = NSURLRequest(URL: url)
                cell.thumbImageView?.setImageWithURLRequest(request, placeholderImage: nil, success:
                    { (request, response, image) -> Void in
                        cell.thumbImageView.image = image
                        self.rt.movies[indexPath.row].thumbnailImage = image
                    }) { (request, response, error) -> Void in
                        
                    }
            }

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "showDetailsSegue" {
                let vc = segue.destinationViewController as! DetailsViewController
                
                selectedRow = movieListTableView.indexPathForSelectedRow!.row
                vc.movie = rt.movies[selectedRow]
            }
        }
    }
}

