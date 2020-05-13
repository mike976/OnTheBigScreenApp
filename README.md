# 
# 🎬 On The Big Screen

Discover new releases and search through The Movie Database (TMDb) for old and recent movies.This app provides details and descriptions for your favourites movies and tv shows, along with images and links to film trailers.

Supports iOS Dark Mode

Features coming soon include:
- Actor Bio
- Search by Genre and Actor
- Explore related movies and tv shows by Actor

v1.0 is now available for download on your iOS devices

## 🔎 About

On the Big Screen is built using Swift and XCode 11

Cocoa Pods used include:

- RxSwift
- AlamoFire & AlamoFireImage
- STRRatingControl

## 🔧 Usage

In order to use the app, you can use the current TMDb API Key provided in this repo or request one by signing up there:
https://www.themoviedb.org

You can update the key it in the file `Services.plist`

## 📫 Author

Michael Bullock - <mikebullock976@gmail.com>

Development Time to Release = 2 weeks

## App Design

- Protocol based design 
- Implementation follows the MVVM design pattern
- Async Await Task pattern implemented to retrieve via the TmDB Web API
- RxSwift was used to observe the user's selection
