# Change Log
All notable changes to this project will be documented in this file.


## 0.6.0 - September 2014
### Added
- Ignore `col` and `colgroup` tags
- Bypass `thead` and `tbody` tags to show the tables correctly

### Changed
- Eliminate ruby warnings on load (thx @vsipuli)
- Treat newlines within text nodes as space
- Remove whitespace between inline tags and punctuation characters


## 0.5.1 - April 2014
### Added
- Adds support for ruby versions 1.9.3 back in
- More options for handling of unknown tags

### Changed
- Bugfixes in `li` indentation behavior


## 0.5.0 - March 2014
**There were some breaking changes, please make sure you don't miss them:**

1. Only ruby versions 2.0.0 or above are supported
2. There is no `Mapper` class any more. Just use `ReverseMarkdown.convert(input, options)`
3. Config option `github_style_code_blocks` changed its name to `github_flavored`

Please open an issue and let me know about it if you have any trouble with the new version.
