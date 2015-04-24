# Ruby Emitter Class
## Abstract

This code was written primarily as an exercise. I have looked at the Ruby programming language with my peripheral vision for many years but not had a reason to actually use it. One of the features I like about nodejs is it's emitters; they allow for efficient use of asynchronous IO. This is something that may well exist in Ruby, I am not sufficiently versed in it to know, but I thought it a reasonable learning experience and a chance to evaluate Ruby first hand.

The code itself makes use of the Ruby thread module and allows listeners tobe associated with emitted objects. A listener can listen for one event or many and many listeners can be associated with one event. They will be chained in the order they are registered in. 

### Emitter
#### Sample Usage

```ruby

require './emitter'

emitter = Emitter.new

emitter.on :hello_world, lambda { |data| puts "1: #{data}" }


emitter.emit :hello_world, "Hello, brave Ruby World!"

```

The above code will result, when executed in a console, result in "1: "Hello, brave Ruby World!" being printed. Not a big deal but you can see the potential. The file test.rb has a slightly more extended example. 

That's it for today. If anyone is interested in this and wants to chat, drop me a line.

-Greg.

   
