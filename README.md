# Jot

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS-blue.svg)

Jot down your ideas.

## 🛠 Branching Strategy

Use `develop` branch for development and `master` for release.

## 🚀 Build Instructions

This project uses the [Swift Package Manager](https://github.com/apple/swift-package-manager) for dependencies. Build instructions:

``` bash
$ git clone https://github.com/zorkdev/Jot.git
$ cd Jot
$ open Jot.xcworkspace
```

To run static analysis on the project, use the analyze script:

``` bash
$ sh Tools/Scripts/analyze.sh {iOS|macOS}
```

Environment variables required for build scripts:

`APPLE_ID`: Developer Apple ID  
`APPLE_ID_PW`: Developer Apple ID app-specific password
