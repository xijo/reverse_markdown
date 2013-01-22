# Summary

Transform existing html into markdown in a simple way, for example if you want to import existings tags into your markdown based application.

[![Build Status](https://secure.travis-ci.org/xijo/reverse_markdown.png?branch=master)](https://travis-ci.org/xijo/reverse_markdown)

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

# Tag support

Only basic html tags are supported right now. However, it should not be to difficult to add some. Feel free to contribute or notify me about missing stuff.

- supported tags: h1, h2, h3, h4, h5, h6, p, em, strong, blockquote, code, img, a, hr, li, ol, ul
- nested lists
- inline and block code

# See as well

- [wmd-editor](http://wmd-editor.com) - Markdown flavored text editor
- [markdown syntax](http://daringfireball.net/projects/markdown) - The markdown syntax specification
- [html_massage](https://rubygems.org/gems/html_massage) - A gem by Harlan T. Wood to convert regular sites into markdown

# Thanks

..to Ben Woosley for his improvements to the first version.

..to Harlan T. Wood for his help with the newer versions.
