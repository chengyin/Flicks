//
//  MoviePosterViewController.swift
//  Flicks
//
//  Created by chengyin_liu on 5/18/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

class MoviePosterViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var scrollView: UIScrollView!

  let imageView = UIImageView()
  var image: UIImage?
  var imageFrame: CGRect?

  @IBOutlet var singleTapRecognizer: UITapGestureRecognizer!
  @IBOutlet var doubleTapRecognizer: UITapGestureRecognizer!

  override func viewDidLoad() {
    super.viewDidLoad()

    imageView.contentMode = .ScaleAspectFill
    scrollView.addSubview(imageView)

    singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
  }

  override func viewWillAppear(animated: Bool) {
    if (image != nil) {
      imageView.image = image!

      let displayHeight = imageFrame!.height
      let displayWidth = imageFrame!.width
      let imageHeight = image!.size.height
      let imageWidth = image!.size.width

      let scale = imageHeight / displayHeight

      let expectedImageHeight = displayHeight
      let expectedImageWidth = imageWidth / scale
      let offset = (displayWidth - expectedImageWidth) / 2

      if (imageFrame != nil) {
        imageView.frame = CGRect.init(x: 0, y: 0, width: expectedImageWidth, height: expectedImageHeight)
      } else {
        imageView.sizeToFit()
      }

      scrollView.contentSize = CGSize(width: expectedImageWidth, height: expectedImageHeight)
      scrollView.contentOffset = CGPoint(x: 0 - offset, y: 0)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func didTapScrollView(sender: AnyObject) {
    if (scrollView.zoomScale > 1.01) {
      return;
    }

    dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func didDoubleTapScrollView(sender: AnyObject) {
    if (scrollView.zoomScale > 1.01) {
      scrollView.setZoomScale(1.0, animated: true)
    } else {
      scrollView.setZoomScale(2.0, animated: true)
    }
  }

  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
