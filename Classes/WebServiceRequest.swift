//
//  WebServiceRequest.swift
//  Classes
//
//  Created by Peter McIntyre on 2015-02-26.
//  Copyright (c) 2015 School of ICT, Seneca College. All rights reserved.
//

import UIKit

class WebServiceRequest {
    
    // How to use this class...

    // In another class, create a property to hold results
    // For a collection, you will need an array of AnyObject
    // For an item, you will need an AnyObject
    
    // Register for a response notification 
    // Write the method that deals with the response
    
    // Then, create an instance of this class, and 
    // call the sendRequestToUrlPath... method
    
    // MARK: - Properties
    
    //var model: Model!
    var urlBase: String?
    var httpMethod: String?
    var headerAccept: String?
    var headerContentType: String?
    var headerAuthorization: String?
    
    var messageBody: AnyObject?
    
    // MARK: - Public methods
    
    func sendRequestToUrlPath(urlPath: String, forDataKeyName dataKeyName: String, from sender: AnyObject, propertyNamed propertyName: String) {
        
        // Assemble the URL
        let url = NSURL(string: "\(urlBase!)\(urlPath)")
        
        // Diagnostic
        println(url?.description)
        
        // Create a session configuration object
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // Create a session object
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        // Create a request object
        let request = NSMutableURLRequest(URL: url!)
        
        // Set its important properties
        request.HTTPMethod = httpMethod!
        request.setValue(headerAccept, forHTTPHeaderField: "Accept")
        
        /*
        // If there is an authToken property
        if countElements(model.authToken) > 0 {
        
        headerAuthorization = model.authToken;
        request.setValue(headerAuthorization, forHTTPHeaderField: "Authorization")
        }
        */
        
        // If a content type header was specifically configured (as an override)
        if let contentType = headerContentType {
            
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        // If a message body was configured...
        if let mb: AnyObject = messageBody {
            
            var error: NSError? = nil
            let message = NSJSONSerialization.dataWithJSONObject(mb, options: nil, error: &error)
            
            if error != nil {
                
                println("Error creating message body: \(error?.description)")
            }
            request.HTTPBody = message
        }
        
        // Diagnostic
        println("Request data...\nHeaders:\n\(request.allHTTPHeaderFields?.description)")
        
        // Reference the app's network activity indicator in the status bar
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // Define a network task; after it's created, it's in a "suspended" state
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // If there's a request error, display it
            if error != nil {
                
                println("Task request error: \(error?.description)")
                
            } else {
                
                // FYI, show some details about the response
                // This code is interesting during development, but you would not leave it in production/deployed code
                let r: NSHTTPURLResponse = response as NSHTTPURLResponse
                println("Response data...\nStatus code: \(r.statusCode)\nHeaders:\n\(r.allHeaderFields.description)")
                
                // Attempt to deserialize the data from the response
                var jsonError: NSError? = nil
                let results: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                
                if jsonError != nil {
                    
                    println("Task request error: \(jsonError?.description)")
                    
                } else {
                    
                    // The request was successful, and deserialization was successful
                    // Therefore, extract the data we want from the dictionary
                    // and assign it to the passed-in property
                    // This version of the code works only with
                    // top/first level key-value pairs in the source JSON data
                    // For example, "Collection" or "Item"
                    sender.setValue((results as NSDictionary)[dataKeyName], forKey: propertyName)
                }
                
                // Next, post a notification for interested listeners
                let completed = "\(_stdlib_getDemangledTypeName(sender))_\(propertyName)_fetch_completed"
                NSNotificationCenter.defaultCenter().postNotificationName(completed, object: nil)
                
                // Diagnostic
                println(completed)
            }
            
            // Finally, reference the app's network activity indicator in the status bar
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
        
        // Now that the task has been fully configured, force it to execute
        task.resume()
    }
    
    
    init(/*modelObject: Model*/) {
        
        // Initial values
        //model = modelObject
        urlBase = "http://dps923winter2015.azurewebsites.net/api"
        httpMethod = "GET"
        headerAccept = "application/json"
        headerContentType = headerAccept
    }
}