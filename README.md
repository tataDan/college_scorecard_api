# README

## About

This application lets users search for colleges in the United States and provides information (eg. number of students, tuition cost, ect.) about the colleges found.

It uses the [collegescorecard API](https://collegescorecard.ed.gov/). Documentation can be found [here](https://collegescorecard.ed.gov/data/api-documentation/).

It uses the Cubit feature of [Bloc](https://bloclibrary.dev/) for state management.

A running implementation of the application can found [here](https://danielgenecasey.net/college-scorecard-api/).

This application has been tested on Windows, the web, and Linux.  (It runs on a Android phone, but the layout looks better on the desktop or web).

## Running & Building

To run or build this application you will first need to obtain a API key.  Go [here](https://collegescorecard.ed.gov/data/api-documentation/) and scroll down to the "API Access and Authentication" section and check the "I'm not a robot" checkbox. Then enter the requested information and click on the "Sign Up" button.

To run the application you can use the `flutter run` command specifying the device like so: `flutter run -d windows --dart-define=COLLEGE_SCORECARD_API_KEY=YOUR API KEY GOES HERE`, replacing "YOUR API KEY GOES HERE" with your API key.

To run and build the application in release mode you can enter a command such as this: `flutter run -d windows --release --dart-define=COLLEGE_SCORECARD_API_KEY=YOUR API KEY GOES HERE`, replacing "YOUR API KEY GOES HERE" with your API key.`.

To build the application in release mode you can enter a command such as this: `flutter build windows --dart-define=COLLEGE_SCORECARD_API_KEY=YOUR API KEY GOES HERE`, replacing "YOUR KEY API GOES HERE" with your API key.

If you are using Visual Studio Code and you want to use the `<F5>` key ("Start Debugging") or the the `<Ctl> <F5>` key combination ("Run without Debugging), then you can create a ".vscode" folder between the "college-scorecard-api" folder and the "college_scorecard_api" folder and then place a "launch.json" file into that folder.  This file should like similar to this:

`{
    "version": "0.1.0",
    "configurations": [
        {
            "name": "Production",
            "request": "launch",
            "type": "dart",
            "program": "college_scorecard_api/lib/main.dart",
            "args": [
                "--dart-define=COLLEGE_SCORECARD_API_KEY=YOUR API KEY GOES HERE"
            ]
        }
    ]
}`

## Using the Application

The user can enter text into one or more of the four search fields.  The search is performed in a "AND" manner and in not a "OR" manner.  For example, if the user enters "Portland" in the city field, then the search will return 27 schools. However, if the user also enters "OR" in the state field as well, then the search will return only 22 schools.

It should be noted that the user must click on the "Get school data" button (or tab to it and press the `<Enter>` key) to invoke the search after any changes are made to any of the search fields.

It should be noted that the collegescorecard API returns its data in pages, each page having a maximum of 20 records. Therefore, to see any additional schools that meet the search criteria, the user should click on the "Next page" button on the documents page.

If the user wants to use the keyboard to scrool through the list of schools (in addition to using the mouse), he or she can use the keyboard to scrool using the `<Page Down>` key or the `<Page Up>` key.

There are six filters available (e.g. "Max Student Size", "Max In-state Tuition", ect.). All of these filters expect a integer number. The user must click on the "Apply Filters" button (or tab to it and press the <Enter> key) to apply the filters after changes are made to any of the filters.

