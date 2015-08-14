//
//  Extensions.swift
//  Toronto 2015
//
//  Created by Peter McIntyre on 2015-03-16.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import CoreData

extension Venue {
    
    func addSport(value: Sport) {
        var items = self.mutableSetValueForKey("sports");
        items.addObject(value)
    }
}
