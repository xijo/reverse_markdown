require 'rexml/document'
include REXML

require "benchmark"
include Benchmark

# reverse markdown for ruby
# author: JO
# date: 14.7.2009
# version: 0.1
# license: GPL

# TODO
# - 
# - 

bla3 = <<-EOF
<h2>heading 1.1</h2>

text *italic* and **bold**.

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

<p>nur ein text! nur eine maschine!</p>
EOF

class ReverseMarkdown
  
  def initialize()
    @li_counter = 0
    @links = []
    @output = ""
    @indent = 0
    @errors = []
  end
  
  def parse_string(string)
    doc = Document.new("<root>\n"+string+"\n</root>")
    root = doc.root
    
    root.elements.each do |element|
      parse_element(element, 'root')
    end

    insert_links()
    @output
  end
  
  def parse_element(element, parent)
    name = element.name.to_sym
    @output << indent(element)
    @output << opening(element, parent)
    
    #@output << text_only_element()
    if (element.has_text? and element.children.size < 2)
      @output << text_node(element, parent)
    end
    
    if element.has_elements? and element.children.size >= 2
      element.children.each do |child|
        # inc intendtion if nested list
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
        
        #close intend if end of nested list
        @indent -= 1 if element.name=~/(ul|ol)/ and parent.eql?(:li)
      end
    end
    @output << ending(element, parent)
  end

  
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
      else
        @errors << "unknown start tag: "+type.name.to_s
        ""
    end
  end
  
  def ending(type, parent)
  case type.name.to_sym
    when :h1
      " #\n\n"
    when :h2
      " ##\n\n"
    when :p
      "\n"
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
    else
      @errors << "  unknown end tag: "+type.name.to_s
      ""
    end
  end
  
  def indent(element)
    str = ""
    @indent.times do
      str << "  " if element.name.eql?('li')
    end
    str
  end
  
  def text_node(element, parent)
    # code block
    if element.name.to_sym.eql?(:code)  and parent.eql?(:pre)
      element.text.gsub("\n","\n    ")
    # blockquote
    elsif parent.eql?(:blockquote)
      element.text.gsub!("\n ","\n>")
    # normal text
    else
      element.text
    end
  end
  
  def insert_links
    @output << "\n"
    @links.each_index do |index|
      @output << "  [#{index+1}]: #{@links[index]}\n"
    end
  end
  
  def print_errors
    @errors.each do |error|
      puts error
    end
  end
  
  def speed_benchmark(string, n)
    initialize()
    bm(15) do |test|
      test.report("reverse markdown:")    { n.times do; parse_string(string); initialize(); end; }
    end
  end
  
end

r = ReverseMarkdown.new

puts r.parse_string(bla3)

r.print_errors

r.speed_benchmark(bla3, 100)
