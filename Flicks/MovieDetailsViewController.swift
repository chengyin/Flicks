//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

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
    }
  }

  // MARK: -

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let dest = segue.destinationViewController as? MoviePosterViewController

    if (dest != nil) {
      dest!.image = self.imageView.image
    }
  }
}
