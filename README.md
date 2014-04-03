# Summary

Transform html into markdown. Useful for example if you want to import html into your markdown based application.

[![Build Status](https://secure.travis-ci.org/xijo/reverse_markdown.png?branch=master)](https://travis-ci.org/xijo/reverse_markdown) [![Gem Version](https://badge.fury.io/rb/reverse_markdown.png)](http://badge.fury.io/rb/reverse_markdown) [![Code Climate](https://codeclimate.com/github/xijo/reverse_markdown.png)](https://codeclimate.com/github/xijo/reverse_markdown) [![Code Climate](https://codeclimate.com/github/xijo/reverse_markdown/coverage.png)](https://codeclimate.com/github/xijo/reverse_markdown)

## Migrate to 0.5.0

There were some breaking changes, please make sure you don't miss them:

1. Only ruby versions 2.0.0 or a above are supported
2. There is no `Mapper` class any more. Just use `ReverseMarkdown.convert(input, options)`
3. Config option `github_style_code_blocks` changed its name to `github_flavored`

Please open an issue and let me know about it if you have any trouble with the new version.

## Requirements

1. [Nokogiri](http://nokogiri.org/)
2. Ruby 2.0.0 or higher

## Installation

Install the gem

```sh
[sudo] gem install reverse_markdown
```

or add it to your Gemfile

```ruby
gem 'reverse_markdown'
```

## Features

- Supports all the established html tags like `h1`, `h2`, `h3`, `h4`, `h5`, `h6`, `p`, `em`, `strong`, `i`, `b`, `blockquote`, `code`, `img`, `a`, `hr`, `li`, `ol`, `ul`, `table`, `tr`, `th`, `td`, `br`
- Module based - if you miss a tag, just add it
- Can deal with nested lists
- Inline and block code is supported
- Supports blockquote


# Usage

## Ruby

You can convert html content as string or Nokogiri document:

```ruby
input  = '<strong>feelings</strong>'
result = ReverseMarkdown.convert input
result.inspect # " **feelings** "
````

## Commandline

It's also possible to convert html files to markdown using the binary:

```sh
$ reverse_markdown file.html > file.md
$ cat file.html | reverse_markdown > file.md
````

## Configuration

The following options are available:

 - `ignore_unknown_tags` (default `true`) - bypass unknown tags instead of raising an `ReverseMarkdown::UnknownTagError`
 - `github_flavored` (default `false`) - use [github flavored markdown](https://help.github.com/articles/github-flavored-markdown) (yet only code blocks are supported)

### As options

Just pass your chosen configuration options in after the input

```ruby
ReverseMarkdown.convert(input, ignore_unknown_tags: false, github_flavored: true)
```

### Preconfigure

Or configure it block style on a initializer level

```ruby
ReverseMarkdown.config do |config|
  config.ignore_unknown_tags = false
  config.github_flavored     = true
end
```


# Related stuff

- [Write custom converters](https://github.com/xijo/reverse_markdown/wiki/Write-your-own-converter) - Wiki entry about how to write your own converter
- [html_massage](https://github.com/harlantwood/html_massage) - A gem by Harlan T. Wood to convert regular sites into markdown using reverse_markdown
- [word-to-markdown](https://github.com/benbalter/word-to-markdown) - Convert word docs into markdown while using reverse_markdown, by Ben Balter
- [markdown syntax](http://daringfireball.net/projects/markdown) - The markdown syntax specification
- [github flavored markdown](https://help.github.com/articles/github-flavored-markdown) - Githubs extension to markdown
- [wmd-editor](http://wmd-editor.com) - Markdown flavored text editor


# Thanks

..to Ben Woosley for his improvements to the first version.

..to Harlan T. Wood for his help with the newer versions.

..and all contributors
