# 
# 🎬 On The Big Screen

Discover new releases and search through The Movie Database (TMDb) for old and recent movies.This app provides details and descriptions for your favourites movies and tv shows, along with images and links to film trailers.

Supports iOS Dark Mode

Features coming soon include:
- Actor Bio
- Search by Genre and Actor
- Explore related movies and tv shows by Actor

v1.0 is now available for download on your iOS devices


<p>
  <img src="https://user-images.githubusercontent.com/63581689/81798327-d0495d00-9507-11ea-9cd0-e3fc1c0f86fe.png" width="210">
  
  <img src="https://user-images.githubusercontent.com/63581689/81798363-dd664c00-9507-11ea-89cd-f780b264124b.png" width="210">

  <img src="https://user-images.githubusercontent.com/63581689/81798412-ece59500-9507-11ea-824a-a22a856f7b71.png" width="210">

  <img src="https://user-images.githubusercontent.com/63581689/81798450-f7079380-9507-11ea-9961-9daa0f6b30c8.png" width="210">
</p>

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


## App Design

v1.0 - from development time to release = 2 weeks

- Protocol based design 
- Implementation follows the MVVM design pattern
- Async Await Task pattern implemented to retrieve data via the TmDB Web API
- RxSwift was used to observe the user's selection
