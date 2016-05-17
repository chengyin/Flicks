//
//  ViewController.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var errorView: UIView!

  var movies = Movies()
  let refreshControl = UIRefreshControl()

  override func viewDidLoad() {
    super.viewDidLoad()

    loadData(true)
    refreshControl.addTarget(self, action: #selector(ViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Error Management

  func hideError() {
    errorView.hidden = true
  }

  func showError(error: NSError) {
    errorLabel.text = error.localizedDescription
    errorView.hidden = false
  }

    // MARK: - Data

  func loadData(showHUD: Bool = false) {
    hideError()
    movies.loadNowPlaying({
      if (showHUD) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
      }
    }, completeHandler: { (error: NSError?) in
      if (showHUD) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
      }

      if (error != nil) {
        self.showError(error!)
        return
      }

      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    })
  }

  // MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
      as! MovieTableViewCell

    cell.showMovie(movies.at(indexPath.row)!)

    return cell
  }

  // MARK: - UITableViewDelegate Methods

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let cell = sender as? UITableViewCell
    let indexPath = self.tableView.indexPathForCell(cell!)
    let movie = movies.at(indexPath!.row)!

    let dest = segue.destinationViewController as? MovieDetailsViewController
    dest?.prepareToShowMovie(movie)
  }
}

