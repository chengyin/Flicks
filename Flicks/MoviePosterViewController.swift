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

  override func viewDidLoad() {
    super.viewDidLoad()

    imageView.contentMode = .ScaleAspectFill
    scrollView.addSubview(imageView)

    // Do any additional setup after loading the view.
  }

  override func viewWillAppear(animated: Bool) {
    if (image != nil) {
      imageView.image = image!
      scrollView.contentSize = image!.size
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func didTapScrollView(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
