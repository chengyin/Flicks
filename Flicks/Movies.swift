//
//  Movies.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

func apiCall(
  endpoint: String,
  beforeStartHandler: (() -> Void)? = nil,
  completeHandler:  (NSData?, NSURLResponse?, NSError?) -> Void
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

  let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: completeHandler)

  task.resume()
}

class Movies: NSObject {
  var _movies:[Movie] = []

  var count: Int {
    get {
      return _movies.count
    }
  }

  func at(index: Int) -> Movie? {
    return _movies[index];
  }

  func loadNowPlaying(
    beforeStartHandler: (() -> Void)? = nil,
    completeHandler: (NSError?) -> Void
    ) {

    apiCall(
      "now_playing",
      beforeStartHandler: beforeStartHandler,
      completeHandler: { (dataOrNil, response, error) in
        if (error != nil) {
          print(error)
          completeHandler(error)
        }

        if let data = dataOrNil {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
          data, options:[]) as? NSDictionary {
            print("response: \(responseDictionary)")

            guard let results = responseDictionary["results"] as? NSArray else { return; }

            self._movies.removeAll()
            for result in results {
              guard let movie = Movie(apiResponse: result as! NSDictionary) else { continue; }

              self._movies.append(movie)
            }

            completeHandler(nil)
          }
        }
    })
  }
}
