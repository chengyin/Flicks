//
//  MoviesAPI.swift
//  Flicks
//
//  Created by chengyin_liu on 5/18/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import Foundation

struct MoviesAPI {
  static func call(
    endpoint: String,
    beforeStartHandler: (() -> Void)? = nil,
    completeHandler:  (NSError?, NSDictionary?) -> Void
    ) {

    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
    let request = NSURLRequest(
      URL: url!,
      cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
      timeoutInterval: 10)

    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate: nil,
      delegateQueue: NSOperationQueue.mainQueue()
    )

    if (beforeStartHandler != nil) {
      beforeStartHandler!()
    }

    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
      if (error != nil) {
        print(error)
        completeHandler(error, nil)
      }

      if let data = dataOrNil {
        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
        data, options:[]) as? NSDictionary {
          print(responseDictionary)
          completeHandler(nil, responseDictionary)
        }
      }
    })
    
    task.resume()
  }
}