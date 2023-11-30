# Release process

- Test the release:
  `ops e2e`
- Edit:
  - ops_team.gemspec
  - src/version.cr
  - CHANGELOG.md
- commit as `release 2.x.y`
- push
- Run `ops build-all`
- Run `ops create-release`
- upload `crops.tar.gz` and `crops.tar.bz2` to release
- update the forumula in `homebrew-crops`
  - change version in URL to match tag from new release
  - run `ops sum` to get the checksum, and put it in the formula
  - `brew reinstall ops` to test
  - commit and push the formula
- release the gem with `ops gem push`
