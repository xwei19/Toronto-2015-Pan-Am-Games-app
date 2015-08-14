//
//  Sport.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-14.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import Foundation
import CoreData

class Sport: NSManagedObject {

    @NSManaged var history: String
    @NSManaged var hostId: NSNumber
    @NSManaged var howItWorks: String
    @NSManaged var logo: NSData
    @NSManaged var photo: NSData
    @NSManaged var sportDescription: String
    @NSManaged var sportName: String
    @NSManaged var venues: NSSet

}
