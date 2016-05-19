//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var poster: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()

    let bgView = UIView()
    bgView.backgroundColor = UIColor(white: 0.6, alpha: 0.2)
    self.selectedBackgroundView = bgView
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: -

  override func prepareForReuse() {
    poster.image = UIImage()
  }

  func showMovie(movie: Movie) {
    self.titleLabel.text = movie.title
    self.overviewLabel.text = movie.overview
    self.poster.af_setImageWithURL(movie.posterURL, imageTransition: .CrossDissolve(0.2))
  }

  func getImage() -> UIImage? {
    return poster.image
  }
}
