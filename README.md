# flickrgram
A tiny application that performs image search using Flickr API

# Features

- Dark theme support
- Smooth infinite scrolling of Flickr images by user search query
- Past searches storing
- Memory efficient
- Failed image reload by tap

## Getting started

These instructions will get you a copy of the project and will allow you running it on your local machine for development and testing purposes. 

See [Installing](#Installing) for notes on how to deploy the project on a live system.

### Prerequisites

- iOS 15.0+
- Xcode 13.0+
- Swift 5

### Installing

Just clone this repo and open `flickrgram/flickrgram.xcodeproj`, then run the application.

```bash
git clone https://github.com/gitvalue/flickr-search.git
```

## Architecture

Here you will see what flickrgram is built of.

### Modules

`flickrgram` project consists of 3 modules:
- ImageLoading
- Networking
- App

### ImageLoading

This module contains the tools are needed for effiecient and safe multithreaded images loading.

All starts with `SyncOperation`, the generous implementation of `NSOperation` abstract class, which allow us to perform and cancel the synchrounous task in an asynchronous manner.

Then goes `ImagePool`, which represents non-persistent size-limited thread-safe storage of images with access complexity of O(1). 

And in conclusion we have `ImageLoader`, which uses `ImagePool` for storing and retrieving previously loaded images and start new loads via `SyncOperation` on the specified queue.

### Networking

This module is the basement of the `flickrgram` app and represents the network layer. It allows us to make requests using plain `Codable` data structures and handle the results the same manner.

### App

Literally the main target. It consists of two screens: `SearchResults` and `Search`, designed using `MVVM` architectual pattern.

## Versioning

This repo do not use any versioning system because I have no plans of maintaining the application in the future

## Troubleshooting

For any questions please fell free to contact [Dmitry Volosach](dmitry.volosach@gmail.com).

## Further steps

- Make maximum concurrent operations count of images loading queue a computable parameter
- Make page size a computable parameter
- Make image pool size a computable parameter or optimal
- Make the loading thumbnails size a computable parameter
- Refactor `Networking` and `ImageLoading` modules in a way that they become fully testable (by injecting dependencies)
- Implement the `PropertyReflectable` protocol which will allow to access private properties for testing purposes
- Add the image preview screen

## Authors

* **Dmitry Volosach** - *Initial work* - dmitry.volosach@gmail.com


