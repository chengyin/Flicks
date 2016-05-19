//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class MovieDetailsViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoView: UIView!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!

  var movie: Movie?
  var placeholderImage: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()
    insertTrailerButton()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    showMovie()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: -

  func prepareToShowMovie(movie: Movie, placeholderImage: UIImage? = nil) {
    self.movie = movie
    self.placeholderImage = placeholderImage
  }

  func showMovie() {
    if (movie != nil) {
      self.titleLabel!.text = movie?.title
      self.overviewLabel!.text = movie?.overview
      self.overviewLabel.sizeToFit()

      self.imageView.af_setImageWithURL(movie!.posterHQURL, placeholderImage: placeholderImage, imageTransition: .CrossDissolve(0.2))

      movie?.getVideos({ (videos) in
        if (videos == nil || videos!.count == 0) {
          self.navigationItem.setRightBarButtonItem(nil, animated: false)
        }
      })
    }
  }

  func insertTrailerButton() {
    let button = UIBarButtonItem()
    button.title = "Trailers"
    button.target = self
    button.action = #selector(MovieDetailsViewController.showTrailerMenu)

    navigationItem.setRightBarButtonItem(button, animated: true)
  }

  func showTrailerMenu() {
    let alert = UIAlertController.init(title: "Trailers", message: nil, preferredStyle: .ActionSheet)

    for video in movie!.videos {
      alert.addAction(UIAlertAction.init(title: video["name"] as? String, style: .Default, handler: {
        (action) in
        self.playMovie(video["key"] as! String)
        }))
    }

    let cancelAction = UIAlertAction.init(title: "Cancel", style: .Cancel) { (action) in
      self.dismissViewControllerAnimated(true, completion: nil)
    }

    alert.addAction(cancelAction)

    self.presentViewController(alert, animated: true, completion: nil)
  }

  func playMovie(id: String) {
    let playerVC = XCDYouTubeVideoPlayerViewController.init(videoIdentifier: id)
    presentMoviePlayerViewControllerAnimated(playerVC)
  }

  // MARK: -

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let dest = segue.destinationViewController as? MoviePosterViewController

    if (dest != nil) {
      dest!.image = self.imageView.image
      dest!.imageFrame = self.imageView.frame
    }
  }
}
