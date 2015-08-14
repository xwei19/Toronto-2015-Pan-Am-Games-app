//
//  NewsList.swift
//  Toronto 2015
//
//  Created by Xiaoli Wei on 2015-04-07.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit

class NewsList: UITableViewController, MWFeedParserDelegate {
    
    // MARK: - Class members
    
    var model: Model!
    var feedItems = [MWFeedItem]()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure a title while the content is being fetched
        self.title = "Loading..."
        
        // Attempt to fetch feed items
        readTheFeed()
    }
    
    func readTheFeed() {
        
        // Feed URL
        let url = NSURL(string: "https://twitrss.me/twitter_user_to_rss/?user=TO2015")
        
        // Create and configure a feed reader
        let reader = MWFeedParser(feedURL: url)
        reader.delegate = self
        reader.feedParseType = ParseTypeFull
        reader.parse()
    }
    
    // MARK: - Feed reader delegate methods
    
    func feedParserDidStart(parser: MWFeedParser) {
        
        // Status bar activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        
        // Re-initialize (remove and re-create)
        // Do this here in case the 'refresh' button was tapped
        self.feedItems = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        
        // Status bar activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        
        self.tableView.reloadData()
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        
        self.title = info.title
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        
        self.feedItems.append(item)
    }
    
    // MARK: - Table view methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feedItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        
        let item = self.feedItems[indexPath.row]
        cell.textLabel!.text = item.title
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toNewsDetail" {
            
            // Get a reference to the item
            let item = self.feedItems[self.tableView.indexPathForSelectedRow()!.row]
            
            // Pass it on to the detail scene
            let vc = segue.destinationViewController as NewsDetail
            vc.title = item.title
            vc.model = self.model
            vc.item = item
        }
    }
}

