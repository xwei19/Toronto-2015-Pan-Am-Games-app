//
//  SportDetail.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-14.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit

class SportDetail: UIViewController {

    // Data object, passed in by the parent view controller in the segue method
    var detailItem: Sport!
    
    @IBOutlet weak var sportPhoto: UIImageView!

    @IBOutlet weak var sportSelector: UISegmentedControl!
    @IBOutlet weak var sportTitle: UILabel!
    @IBOutlet weak var sportDetails: UITextView!
    @IBAction func sportChanged(sender: AnyObject) {
        if(sportSelector.selectedSegmentIndex==0){
            sportTitle.text = "Description"
            sportDetails.text = detailItem.sportDescription
        }
        if(sportSelector.selectedSegmentIndex==1){
            sportTitle.text = "History"
            sportDetails.text = detailItem.history
        }
        if(sportSelector.selectedSegmentIndex==2){
            sportTitle.text="How it Works"
            sportDetails.text = detailItem.howItWorks
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Simply display some data in the debug console
        
        sportTitle.text = "Description"
        sportDetails.text = detailItem.sportDescription
        
        /*
        let att1 = detailItem.sportDescription
        let att2 = detailItem.history
        println("Detail item: \(att1), \(att2)")
        let att3 = detailItem.venues.count
        println("\nAt \(att3) venues")
            
        for vn in detailItem.venues {
            
            let venue = vn as Venue
            println("...in venue \(venue.venueName)")
        }
        */

        // Display the photo, sized to fit
        sportPhoto.contentMode = UIViewContentMode.ScaleAspectFit
        sportPhoto.image = UIImage(data: detailItem.photo)
    }

}
