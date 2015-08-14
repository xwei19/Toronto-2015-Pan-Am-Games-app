//
//  NewsDetail.swift
//  Toronto 2015
//
//  Created by Xiaoli Wei on 2015-04-07.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit

class NewsDetail: UIViewController {
    
    // MARK: - Class members
    
    var model: Model!
    var item: MWFeedItem!

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    @IBOutlet weak var itemSummary: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Configure the user interface
        
        itemTitle.text = item.title
        
        // Format the date
        
        let df = NSDateFormatter();
        df.dateStyle = .LongStyle
        df.timeStyle = .MediumStyle
        itemDate.text = df.stringFromDate(item.date)
        
        // The author of this code decided that the UIWebView font
        // should be similar to the iOS system font
        // The following string-replacment code wraps the 'item.summary' string
        // inside a styled <div> element
        
        let styledItemSummary = "<div style=\"font-family: sans-serif;\">\(item.summary)</div>"
        itemSummary.loadHTMLString(styledItemSummary, baseURL: nil)
    }

}
