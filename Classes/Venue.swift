//
//  Venue.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-14.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import Foundation
import CoreData

class Venue: NSManagedObject {

    @NSManaged var hostId: NSNumber
    @NSManaged var map: NSData
    @NSManaged var photo: NSData
    @NSManaged var venueDescription: String
    @NSManaged var venueName: String
    @NSManaged var location: String
    @NSManaged var sports: NSSet

}
