<div align="center">
  <img src="benchTime/Assets.xcassets/bench-time.imageset/bench-time.png" alt="BenchTime Logo" width="400"/>
</div>

## Introduction
Bench Time enables users to find, rate, and review benches worldwide. Bench Time prides itself on the removal of a social media aspect, serving as a log for benches.

## :ledger: Table of Contents

- [Features](#white_check_mark-features)
- [Usage](#zap-usage)
  - [Requirements](#pushpin-requirements)
  - [Installation](#electric_plug-installation)
- [Future Features](#seedling-future-features)
- [License](#lock-license)

## :white_check_mark: Features
### Bench Discovery
  - [x] **Map View:** Shows nearby benches with associated reviews on a GPS-enabled map, including options to zoom, recenter, and search by location. Users can return to their current or searched location.
  - [x] **Details for Each Bench:** Information on the bench material, seating capacity, maintenance date, and any associated costs or permissions.

### Reviews
  - [x] **New Reviews:** Let users add a title, a description, a rating out of 5 stars, and upload photos for more detailed feedback.
  - [x] **My Reviews:** A compliation of a user's reviews in a convenient view.
  - [x] **Update or Delete Reviews:** Let users update or delete their own reviews.
        
### User
  - [x] **Account Creation:** Let users sign up by providing an email, username, and password.
  - [x] **Authentication:** Users can log in with their credentials (email + password).
  - [x] **Session Management:** After logging in, users can stay logged in until they log out manually.
  - [x] **User Profile:** Allows users to set username, profile picture, and update these when desired.
  - [x] **Password:** Users can update password.
  - [x] **Delete Account:** Account and associated reviews can be deleted.

### Feed
  - [x] **Home Page:** Shows reviews by users worldwide.

## :zap: Usage

### :pushpin: Requirements
- iOS 17.0+
- Xcode 15.0+

### :electric_plug: Installation
Install the dependencies using **CocoaPods** by navigating to the project file and run:

```
$ pod install
```

Open the workspace created instead of the ```.xcodeproj``` file to ensure that the project has access to the dependencie:

```
$ open benchTime.xcworkspace
```

## :seedling: Future Features
### Bench Discovery
  - [ ] **Filter Options:** Filter benches by amenities (e.g., shade, accessibility, proximity to landmarks, nearby facilities).

### Reviews
  - [ ] **Tagging System:** Users can tag benches with specific features like “shaded,” “scenic,” or “quiet.”
  - [ ] **Filter Options:** Filter through user's reviews.

### Feed
  - [ ] **Browse Location:** Set a location to browse through on the home page.

##  :lock: License

This project uses data sourced from **OpenStreetMap** via **Overpass Turbo**, which is licensed under the **Open Database License (ODbL)**. 

- You must attribute OpenStreetMap and its contributors.
- You may copy, modify, distribute, and use the data as long as you attribute OpenStreetMap.
- You cannot use the data for unlawful purposes.

For more details, visit [OpenStreetMap License](https://www.openstreetmap.org/copyright).

