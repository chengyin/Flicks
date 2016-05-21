# Flicks

Submitted by: Chengyin Liu

Time spent: 10 hours spent in total

## User Stories

The following user stories must be completed:

- [X] User can view a list of movies currently playing in theaters from The Movie Database. Poster images must be loaded asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for movies API. You can use one of the 3rd party libraries listed on CocoaControls.
- [X]User sees an error message when there's a networking error. You may not use UIAlertController or a 3rd party library to display the error. See this screenshot for what the error message should look like.
- [X] User can pull to refresh the movie list.
- [X] Add a tab bar for Now Playing or Top Rated movies. (high)
- [X] Implement a UISegmentedControl to switch between a list view and a grid view. (high)

The following advanced user stories are optional: (high, med, and low refer to the effort to implement the feature, with high being the most work and low being the least)

- [X] Add a search bar. (med)
- [X] All images fade in as they are loading. (low)
- [X] For the large poster, load the low-res image first and switch to high-res when complete. (low)
- [X] Customize the highlight and selection effect of the cell. (low)
- [X] Customize the navigation bar. (low)
- [X] Tapping on a movie poster image shows the movie poster as full screen and zoomable. (med)
- [X] User can tap on a button to play the movie trailer. (med)

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![Walkthrough GIF](./Flicks.gif)

## License

    Copyright 2016 Chengyin Liu

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

## Issues

- Parsing JSON is non-intuitive. A lot of guarding and hard to know where the error was, array casting often ends in errors
- Weird extra space at the table header in navigation controller
- Scroll view and autolayoutting
- How to support two views in prepareForSegue
- Memory concerns about list vs grid
- The navbar doesn't get updated until sugue finishes, looks weird

