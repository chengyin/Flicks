//
//  Movies.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

func movieAPICall(
  endpoint: String,
  beforeStartHandler: (() -> Void)? = nil,
  completeHandler:  (NSError?, [Movie]?) -> Void
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
        print("response: \(responseDictionary)")

        guard let results = responseDictionary["results"] as? NSArray else { return; }
        var movies: [Movie] = []

        for result in results {
          guard let movie = Movie(apiResponse: result as! NSDictionary) else { continue; }

          movies.append(movie)
        }

        completeHandler(nil, movies)
      }
    }
  })

  task.resume()
}

class Movies: NSObject {
  enum MovieCollections {
    case NowPlaying
    case TopRated
  }

  var _movies:[Movie] = []

  var count: Int {
    get {
      return _movies.count
    }
  }

  init(_ movies: [Movie]? = nil) {
    if (movies != nil) {
      _movies = movies!
    }
  }

  func at(index: Int) -> Movie? {
    return index < _movies.count ? _movies[index] : nil;
  }

  func load(
    type: MovieCollections,
    beforeStartHandler: (() -> Void)? = nil,
    completeHandler: (NSError?) -> Void
  ) {
    switch type {
    case .NowPlaying:
      loadEndpoint("now_playing", beforeStartHandler: beforeStartHandler, completeHandler: completeHandler)
    case .TopRated:
      loadEndpoint("top_rated", beforeStartHandler: beforeStartHandler, completeHandler: completeHandler)
    }
  }

  func loadEndpoint(
    endpoint: String,
    beforeStartHandler: (() -> Void)? = nil,
    completeHandler: (NSError?) -> Void
    ) {
    movieAPICall(
      endpoint,
      beforeStartHandler: beforeStartHandler,
      completeHandler: { (error, movies) in
        if (error != nil) {
          print(error)
          completeHandler(error)
          return
        }

        self._movies = movies ?? []
        completeHandler(nil)
    })
  }

  func filter(keyword: String?) -> Movies {
    if (keyword == nil || keyword == "") {
      return self
    }

    let lower = keyword?.lowercaseString

    return Movies(_movies.filter { (movie) -> Bool in
      return movie.title.lowercaseString.containsString(lower!)
    })
  }
}
