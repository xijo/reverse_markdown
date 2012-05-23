require 'rexml/document'
require 'benchmark'
include REXML
include Benchmark

# reverse markdown for ruby
# author: JO
# e-mail: xijo@gmx.de
# date: 14.7.2009
# version: 0.1
# license: GPL
# taken from https://github.com/xijo/reverse-markdown/raw/master/reverse_markdown.rb

# TODO
# - ol numbering is buggy, in fact doesn't matter for markdown code
# -

class ReverseMarkdown

  # set basic variables:
  # - @li_counter: numbering list item (li) tags in an ordered list (ol)
  # - @links:      hold the links for adding them to the bottom of the @output
  #                this means 'reference style', please take a look at http://daringfireball.net/projects/markdown/syntax#link
  # - @outout:     fancy markdown code in here!
  # - @indent:     control indention level for nested lists
  # - @errors:     appearing errors, like unknown tags, go into this array
  def initialize()
    @li_counter = 0
    @links = []
    @output = ""
    @indent = 0
    @errors = []
  end

  # Invokes the HTML parsing by using a string. Returns the markdown code in @output.
  # To garantuee well-formed xml for REXML a <root> element will be added, but has no effect.
  # After parsing all elements, the 'reference style'-links will be inserted.
  def parse_string(string)
    doc = Document.new("<root>\n"+string+"\n</root>")
    parse_element(doc.root, :none)
    insert_links()
    @output
  end

  # Parsing an element and its children (recursive) and writing its markdown code to @output
  # 1. do indent for nested list items
  # 2. add the markdown opening tag for this element
  # 3a. if element only contains text, handle it like a text node
  # 3b. if element is a container handle its children, which may be text- or element nodes
  # 4. finally add the markdown ending tag for this element
  def parse_element(element, parent)
    name = element.name.to_sym
    # 1.
    @output << indent() if name.eql?(:li)
    # 2.
    @output << opening(element, parent)

    # 3a.
    if (element.has_text? and element.children.size < 2)
      @output << text_node(element, parent)
    end

    # 3b.
    if element.has_elements?
      element.children.each do |child|
        # increase indent if nested list
        @indent += 1 if element.name=~/(ul|ol)/ and parent.eql?(:li)

        if child.node_type.eql?(:element)
          parse_element(child, element.name.to_sym)
        else
          if parent.eql?(:blockquote)
            @output << child.to_s.gsub("\n ", "\n>")
          else
            @output << child.to_s
          end
        end

        # decrease indent if end of nested list
        @indent -= 1 if element.name=~/(ul|ol)/ and parent.eql?(:li)
      end
    end

    # 4.
    @output << ending(element, parent)
  end

  # Returns opening markdown tag for the element. Its parent matters sometimes!
  def opening(type, parent)
    case type.name.to_sym
      when :h1
        "# "
      when :li
        parent.eql?(:ul) ? " - " : " "+(@li_counter+=1).to_s+". "
      when :ol
        @li_counter = 0
        ""
      when :ul
        ""
      when :h2
        "## "
      when :h3
        "### "
      when :h4
        "#### "
      when :h5
        "##### "
      when :h6
        "###### "
      when :em
        "*"
      when :strong
        "**"
      when :blockquote
        # remove leading newline
        type.children.first.value = ""
        "> "
      when :code
        parent.eql?(:pre) ? "    " : "`"
      when :a
        "["
      when :img
        "!["
      when :hr
        "----------\n\n"
      when :root
        ""
      else
        @errors << "unknown start tag: "+type.name.to_s
        ""
    end
  end

  # Returns the closing markdown tag, like opening()
  def ending(type, parent)
    case type.name.to_sym
      when :h1
        " #\n\n"
      when :h2
        " ##\n\n"
      when :h3
        " ###\n\n"
      when :h4
        " ####\n\n"
      when :h5
        " #####\n\n"
      when :h6
        " ######\n\n"
      when :p
        parent.eql?(:root) ? "\n\n" : "\n"
      when :ol
        parent.eql?(:li) ? "" : "\n"
      when :ul
        parent.eql?(:li) ? "" : "\n"
      when :em
        "*"
      when :strong
        "**"
      when :li
        ""
      when :blockquote
        ""
      when :code
        parent.eql?(:pre) ? "" : "`"
      when :a
        @links << type.attribute('href').to_s
        "][" + @links.size.to_s + "] "
      when :img
        @links << type.attribute('src').to_s
        "" + type.attribute('alt').to_s + "][" + @links.size.to_s + "] "
        "#{type.attribute('alt')}][#{@links.size}] "
      when :root
        ""
      else
        @errors << "  unknown end tag: "+type.name.to_s
        ""
    end
  end

  # Perform indent: two space, @indent times - quite simple! :)
  def indent
    str = ""
    @indent.times do
      str << "  "
    end
    str
  end

  # Return the content of element, which should be just text.
  # If its a code block to indent of 4 spaces.
  # For block quotation add a leading '>'
  def text_node(element, parent)
    if element.name.to_sym.eql?(:code) and parent.eql?(:pre)
      element.text.gsub("\n","\n    ") << "\n"
    elsif parent.eql?(:blockquote)
      element.text.gsub!("\n ","\n>")
    else
      element.text
    end
  end

  # Insert the mentioned reference style links.
  def insert_links
    @output << "\n"
    @links.each_index do |index|
      @output << "  [#{index+1}]: #{@links[index]}\n"
    end
  end

  # Print out all errors, that occured and have been written to @errors.
  def print_errors
    @errors.each do |error|
      puts error
    end
  end

  # Perform a benchmark on a given string n-times.
  def speed_benchmark(string, n)
    initialize()
    bm(15) do |test|
      test.report("reverse markdown:")    { n.times do; parse_string(string); initialize(); end; }
    end
  end

end

if __FILE__ == $0

  # Example HTML Code for parsing
  example = <<-EOF
This text, though not within an element, should also be shown.

<h2>heading 1.1</h2>

<p>text *italic* and **bold**.</p>

<pre><code>text *italic* and **bold**.
sdfsdff
sdfsd
sdf sdfsdf
</code></pre>

<blockquote>
  <p>text <em>italic</em> and <strong>bold</strong>. sdfsdff
  sdfsd sdf sdfsdf</p>
</blockquote>

<p>asdasd <code>sdfsdfsdf</code> asdad <a href="http://www.bla.de">link text</a></p>

<p><a href="http://www.bla.de">link <strong>text</strong></a></p>

<ol>
<li>List item</li>
<li>List <em>item</em>
<ol><li>List item</li>
<li>dsfdsf
<ul><li>dfwe</li>
<li>dsfsdfsdf</li></ul></li>
<li>lidsf <img src="http://www.dfgdfg.de/dsf.jpe" alt="item" title="" /></li></ol></li>
<li>sdfsdfsdf
<ul><li>sdfsdfsdf</li>
<li>sdfsdfsdf <strong>sdfsdf</strong></li></ul></li>
</ol>

<blockquote>
  <p>Lorem ipsum dolor sit amet, consetetur
  voluptua. At vero eos et accusam et
  justo duo dolores et ea rebum. Stet
  clita kasd gubergren, no sea takimata
  sanctus est Lorem ipsum dolor sit
  amet. <em>italic</em></p>
</blockquote>

<hr />

<blockquote>
  <p>Lorem ipsum dolor sit amet, consetetur
  sadipscing elitr, sed diam nonumy
  eirmod tempor invidunt ut labore et
  dolore magna aliquyam erat, sed</p>
</blockquote>

This should also be shown, even if it's not wrapped in an element.

<p>nur ein text! nur eine maschine!</p>

This text should not be invisible!
EOF

  r = ReverseMarkdown.new

  puts r.parse_string(example)

  #r.print_errors

  #r.speed_benchmark(example, 100)
end
