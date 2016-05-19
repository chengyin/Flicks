//
//  ViewController.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController:
  UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  UICollectionViewDelegateFlowLayout,
  UICollectionViewDataSource,
  UISearchBarDelegate
{
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var displayModeSegmentedControl: UISegmentedControl!

  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var searchBarButton: UIBarButtonItem!

  let refreshControl = UIRefreshControl()
  let refreshControlGrid = UIRefreshControl()
  let searchBar = UISearchBar()

  var originalNavigationTitleView: UIView?

  var movies = Movies()
  var movieType: Movies.MovieCollections = .NowPlaying

  var isSearching = false
  var searchKeyword = ""

  enum DisplayMode {
    case Grid, List
  }

  var displayMode = DisplayMode.Grid

  override func viewDidLoad() {
    super.viewDidLoad()

    searchBar.delegate = self

    setTitle()
    setDisplayMode(.Grid)

    originalNavigationTitleView = navigationItem.titleView
    
    loadData(true)
    refreshControl.addTarget(self, action: #selector(ViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
    refreshControlGrid.addTarget(self, action: #selector(ViewController.loadData), forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    collectionView.insertSubview(refreshControlGrid, atIndex: 0)
  }

  override func viewWillAppear(animated: Bool) {
    var bottom: CGFloat = 0.0

    if (tabBarController != nil) {
      bottom = tabBarController!.tabBar.frame.size.height
    }

    tableView.contentInset = UIEdgeInsetsMake(64, 0, bottom, 0);
    collectionView.contentInset = UIEdgeInsetsMake(64, 0, bottom, 0);
  }

  func setTitle() {
    switch movieType {
    case .NowPlaying:
      title = "Now Playing"
    default:
      title = "Top Rated"
    }
  }

  func setDisplayMode(mode: DisplayMode) {
    displayMode = mode

    switch mode {
    case .Grid:
      collectionView.hidden = false
      tableView.hidden = true
    case .List:
      collectionView.hidden = true
      tableView.hidden = false
    }

    reloadData()
  }

  @IBAction func didDisplayModeControlValueChange(sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      setDisplayMode(.Grid)
    case 1:
      setDisplayMode(.List)
    default:
      setDisplayMode(.Grid)
    }
  }

  func reloadData() {
    switch displayMode {
    case .Grid:
      self.collectionView.reloadData()
    case .List:
      self.tableView.reloadData()
    }
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
    movies.load(
      movieType,
      beforeStartHandler: {
        if (showHUD) {
          MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
      }, completeHandler: { (error: NSError?) in
        self.refreshControl.endRefreshing()
        self.refreshControlGrid.endRefreshing()

        if (showHUD) {
          MBProgressHUD.hideHUDForView(self.view, animated: true)
        }

        if (error != nil) {
          self.showError(error!)
          return
        }

        self.reloadData()
    })
  }

  func getMovies() -> Movies {
    if (!isSearching) {
      return movies
    } else {
      return movies.filter(searchKeyword)
    }
  }

  // MARK: - UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableView.hidden ? 0 : getMovies().count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)
      as! MovieTableViewCell

    cell.showMovie(getMovies().at(indexPath.row)!)

    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }

  // MARK: - UICollectionViewDataSource

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView.hidden ? 0 : getMovies().count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieGridCell", forIndexPath: indexPath) as! MovieCollectionViewCell
    let movie = getMovies().at(indexPath.row)

    if (movie != nil) {
      gridCell.showMovie(movie!)
    }

    return gridCell
  }

  // MARK: - UICollectionViewDelegateFlowLayout
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let boundWidth = collectionView.bounds.width
    let itemWidth = boundWidth / 2.0 - 1
    let itemHeight = itemWidth * 40.0 / 27.0

    return CGSizeMake(itemWidth, itemHeight)
  }

  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var indexPath: NSIndexPath?
    var placeholderImage: UIImage? 

    if let cell = sender as? MovieTableViewCell {
      indexPath = self.tableView.indexPathForCell(cell)
      placeholderImage = cell.getImage()
    } else if let cell = sender as? MovieCollectionViewCell {
      indexPath = self.collectionView.indexPathForCell(cell)
      placeholderImage = cell.getImage()
    }

    let movie = getMovies().at(indexPath!.row)!

    let dest = segue.destinationViewController as? MovieDetailsViewController
    dest?.prepareToShowMovie(movie, placeholderImage: placeholderImage)
  }

  // MARK: - Search

  @IBAction func didTapSearch(sender: UIBarButtonItem) {
    if (isSearching) {
      isSearching = false
      searchBarButton.title = "Search"
      searchBar.text = ""
      navigationItem.titleView = originalNavigationTitleView
      reloadData()
    } else {
      isSearching = true
      searchBarButton.title = "Cancel"
      navigationItem.titleView = searchBar
      searchBar.becomeFirstResponder()
    }
  }

  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    searchKeyword = searchText
    reloadData()
  }
}

