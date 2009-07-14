require 'rexml/document'
require 'xmlsimple'
include REXML

# reverse markdown for ruby
# author: JO
# date: 14.7.2009
# version: 0.1
# license: GPL

# TODO
# - 
# - 

bla3 = <<-EOF
<div>
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

<blockquote>
  <p>Lorem ipsum dolor sit amet, consetetur
  sadipscing elitr, sed diam nonumy
  eirmod tempor invidunt ut labore et
  dolore magna aliquyam erat, sed</p>
</blockquote>

</div>
EOF

@@li_counter = 0
@@links = []

def opening(type, parent)
  case type.name
    when /h1/
      "# "
    when /li/
      parent.eql?('ul') ? " - " : " "+(@@li_counter+=1).to_s+". "
    when /ol|ul/
      @@li_counter = 0
      ""
    when /\Ah2/
      "## "
    when /em/
      "*"
    when /strong/
      "**"
    when /blockquote/
      # remove leading newline
      type.children.first.value = ""
      "> "
    when /code/
      parent.eql?('pre') ? "    " : "`"
    when /a/
      "["
    when /img/
      "!["
    else
      ""
  end
end

def ending(type, parent)
  case type.name
    when /h1/
      " #\n\n"
    when /p/
      "\n"
    when /ul|ol/
      parent.eql?('li') ? "" : "\n"
    when /h2/
      " ##\n\n"
    when /em/
      "*"
    when /strong/
      "**"
    when /li|blockquote/
      ""
    when /code/
      parent.eql?('pre') ? "" : "`"
    when /a/
      @@links << type.attribute('href').to_s
      "][" + @@links.size.to_s + "] "
    when /img/
      @@links << type.attribute('src').to_s
      "" + type.attribute('alt').to_s + "][" + @@links.size.to_s + "] "
      "#{type.attribute('alt')}][#{@@links.size}] "
    else
      "type: " + type.name + "\n" 
    end
end

def parse_element(element, str, parent, intend=0)
  # intend elements, i.g. list items
  intend.times do
    str << "  " if element.name.eql?('li')
  end

  str << opening(element, parent)
  
  if (element.has_text? and element.children.size < 2)
    # code block
    if element.name.eql?('code')  and parent.eql?('pre')
      str << element.text.gsub("\n","\n    ")
    # blockquote
    elsif parent.eql?('blockquote')
      str << element.text.gsub!("\n ","\n>")
    # normal text
    else
      str << element.text
    end
  end


  
  if element.has_elements?
    element.children.each do |child|
      # inc intendtion if nested list
      intend += 1 if element.name=~/(ul|ol)/ and parent.eql?('li')
      
      if child.node_type.eql?(:element)
        parse_element(child, str, element.name, intend)
      else
        if parent.eql?('blockquote')
          str << child.to_s.gsub("\n ", "\n>")
        else
          str << child.to_s
        end
      end

      
      #close intend if end of nested list
      intend -= 1 if element.name=~/(ul|ol)/ and parent.eql?('li')
    end


  end
  str << ending(element, parent)
  
end

doc = Document.new(bla3)
root = doc.root

#puts root.elements[1].methods.inspect

output = ""

root.elements.each do |element|
  str = ""
  parse_element(element, str, 'root')
  output << str
end

# process links
@@links.each_index do |index|
  output << "  [#{index+1}]: #{@@links[index]}\n"
end

print output

puts '-------'

puts root.elements['pre'][0].text

root.elements[3].children.each do |child|
  #puts child.node_type.eql?(:element)
end
