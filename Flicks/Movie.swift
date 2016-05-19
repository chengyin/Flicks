//
//  Movie.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

let IMG_PREFIX_HQ = "https://image.tmdb.org/t/p/original"
let IMG_PREFIX_MQ = "https://image.tmdb.org/t/p/w500"
let IMG_PREFIX_LQ = "https://image.tmdb.org/t/p/w185"

class Movie: NSObject {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String

  var videos: [[String: Any?]] {
    get {
      var results = [[String: Any?]]()

      if (apiVideos != nil) {
        for video in apiVideos! {
          if (video["site"] as? String == "YouTube") {
            results.append([
              "name": video["name"],
              "key": video["key"]
            ])
          }
        }
      }

      return results
    }
  }

  private var apiVideos: [NSDictionary]?

  var posterURL: NSURL {
    get {
      return NSURL(string: "\(IMG_PREFIX_LQ)\(posterPath)")!
    }
  }

  var posterMQURL: NSURL {
    get {
      return NSURL(string: "\(IMG_PREFIX_MQ)\(posterPath)")!
    }
  }

  var posterHQURL: NSURL {
    get {
      return NSURL(string: "\(IMG_PREFIX_HQ)\(posterPath)")!
    }
  }

  init(id: Int, title: String, overview: String, posterPath: String) {
    self.id = id
    self.title = title
    self.overview = overview
    self.posterPath = posterPath
  }

  convenience init?(apiResponse: NSDictionary) {
    guard let id = apiResponse["id"] as? Int,
      let title = apiResponse["title"] as? String,
      let overview = apiResponse["overview"] as? String,
      let posterPath = apiResponse["poster_path"] as? String
    else { return nil }

    self.init(id: id, title: title, overview: overview, posterPath: posterPath)
  }

  // MARK: -

  func getVideos(completionHandler: ([[String: Any?]]?) -> Void) {
    if (apiVideos != nil) {
      completionHandler(videos)
    } else {
      MoviesAPI.call(
        "\(id)/videos",
        completeHandler: { (error, response) in
          if (error == nil && response != nil) {
            //let results = response!["results"] as! [[String: Any?]]
            guard let results = response!["results"] as? [NSDictionary] else { return; }
            self.apiVideos = results
            completionHandler(self.videos)
          }
      })
    }
  }
}

