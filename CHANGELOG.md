# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2021-12-02

### Added

- This change log
- Push Docker images for branch "test" as well
- Script outputs the current version with -h

## [1.0.1] - 2020-12-23

### Fixed

- Fix bug with GHCR authentication

## [1.0.0] - 2020-12-22

### Added

- `build.bash` build script for consistent builds across platforms
- Sample C# .NET Core project to exercise the build script
- `azure-pipelines-yml` to show how to call the script from Azure
- GitHub workflow `build.yml` to show how to call the script as a GitHub Action

[unreleased]: https://github.com/mcld/buildscript/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/mcld/buildscript/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/mcld/buildscript/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/mcld/buildscript/releases/tag/v1.0.0
