# Summary

Transform existing html into markdown in a simple way, for example if you want to import existings tags into your markdown based application.

[![Build Status](https://secure.travis-ci.org/xijo/reverse_markdown.png?branch=master)](https://travis-ci.org/xijo/reverse_markdown) [![Gem Version](https://badge.fury.io/rb/reverse_markdown.png)](http://badge.fury.io/rb/reverse_markdown)

# Requirements

Depends on [Nokogiri](http://nokogiri.org/).

# Installation

Install the gem:

  [sudo] gem install reverse_markdown

If you want to use it in Rails context, add it to your Gemfile:

```ruby
gem 'reverse_markdown'
```

# Synopsis

Given you have html content as string or Nokogiri document or element just pass it over to the module like this:

```ruby
ReverseMarkdown.parse content
````

However, the old syntax is still supported:

```ruby
ReverseMarkdown.parse_element content
ReverseMarkdown.parse_string content
````

You can also convert html files to markdown from the command line:

```sh
$ reverse_markdown file.html > file.markdown
$ cat file.html | reverse_markdown > file.markdown
````

Additionally there is a support for github-like multiline code which is indented with "`":

```ruby
ReverseMarkdown.parse_string(input, github_style_code_blocks: true)
````

# Tag support

Only basic html tags are supported right now. However, it should not be to difficult to add some. Feel free to contribute or notify me about missing stuff.

- supported tags: `h1`, `h2`, `h3`, `h4`, `h5`, `h6`, `p`, `em`, `strong`, `i`, `b`, `blockquote`, `code`, `img`, `a`, `hr`, `li`, `ol`, `ul`, `table`, `tr`, `th`, `td`
- nested lists
- inline and block code

# See as well

- [wmd-editor](http://wmd-editor.com) - Markdown flavored text editor
- [markdown syntax](http://daringfireball.net/projects/markdown) - The markdown syntax specification

# Used for

1. [html_massage](https://github.com/harlantwood/html_massage) - A gem by Harlan T. Wood to convert regular sites into markdown
2. [word-to-markdown](https://github.com/benbalter/word-to-markdown) - Convert word docs into markdown, by Ben Balter

# Thanks

..to Ben Woosley for his improvements to the first version.

..to Harlan T. Wood for his help with the newer versions.
