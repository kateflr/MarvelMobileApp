Marvel Comics App

A Flutter application that showcases Marvel characters and their comic appearances.

# Setup and Installation
- Clone the repository: git clone https://github.com/kateflr/MarvelMobileApp.git
- Navigate to the project directory: cd MarvelMobileApp
- Install dependencies: flutter pub get

# Running the Application
- Ensure Flutter is installed and set up on your machine.
- Connect a mobile device or start an emulator.
- Run the app: flutter run

# Code Structure and Architecture
- The code structure of the Marvel Comics App follows a standard Flutter project structure, with the main code located in the lib directory. Here's an overview:
- lib/
	- models/: Contains Dart classes defining the data models used in the application, such as Character.dart and Comic.dart.
	- screens/: Contains the different screens of the application.
		- MainScreen.dart: The main screen of the application, displaying a list of Marvel characters.
		- DetailScreen.dart: Screen for displaying details of a selected character, including their description and associated
		  comics.
		- ComicDetailWebPage.dart: Screen for displaying detailed comic information in webview.
		- SplashScreen: Introductory screen of the application containing the marvel logo.
	- main.dart: Entry point of the application, where the app is initialized and the main widget tree is built.
	- requests.dart: Defines functions for making API requests to fetch Marvel characters and comics.		
		
# Packages Used
- http: Dart package for making HTTP requests to the Marvel API.
- crypto: Dart package for hashing data, used for generating API authentication tokens.
- carousel_slider: Flutter package for creating carousel sliders, used for displaying comics in the app.
- webview_flutter: Flutter plugin for embedding web views in the application, used for displaying detailed comic information.

