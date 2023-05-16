# Release process

- Test the release:
  `ops e2e`
- Edit:
  - ops_team.gemspec
  - src/version.cr
  - CHANGELOG.md
- commit as `release 2.x.y`
- Run the following commands:
  ```
  ops build
  ops build-platforms
  ops build-release
  ```
- [Create a release](https://github.com/nickthecook/crops/releases) in the GitHub project.
- update the forumula in `homebrew-crops`
  - change version in URL to match tag from new release
  - download the file pointed to by the new URL
  - `sha256sum crops-2.x.y.tar.xz`
  - update the checksum in the Formula
  - `brew reinstall ops` to test
  - commit and push the formula
- release the gem with `ops gem push`
