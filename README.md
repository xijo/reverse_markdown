# Summary

Transform existing html into markdown in a simple way, for example if you want to import existings tags into your markdown based application.

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

# Tag support

Only basic html tags are supported right now. However, it should not be to difficult to add some. Feel free to contribute or notify me about missing stuff.

- supported tags: h1, h2, h3, h4, h5, h6, p, em, strong, blockquote, code, img, a, hr, li, ol, ul
- nested lists
- inline and block code

# See as well

- [wmd-editor](http://wmd-editor.com)
- [markdown syntax](http://daringfireball.net/projects/markdown)

# Thanks

..to Ben Woosley for his improvements to the original script.