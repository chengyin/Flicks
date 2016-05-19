//
//  MovieCollectionViewCell.swift
//  Flicks
//
//  Created by chengyin_liu on 5/17/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var image: UIImageView!

  override func prepareForReuse() {
    image.image = UIImage()
  }

  func showMovie(movie: Movie) {
    image.af_setImageWithURL(movie.posterMQURL, imageTransition: .CrossDissolve(0.2))
  }

  func getImage() -> UIImage? {
    return image.image
  }
}
