# Ruby Emitter Class
## Abstract

This code was written primarily as an exercise. I have looked at the Ruby programming language with my peripheral vision for many years but not had a reason to actually use it. One of the features I like about nodejs is it's emitters; they allow for efficient use of asynchronous IO. This is something that may well exist in Ruby, I am not sufficiently versed in it to know, but I thought it a reasonable learning experience and a chance to evaluate Ruby first hand.

The code itself makes use of the Ruby thread module. Todays installment does not have a once method and it is an important part of an emitter. I will modify it the next time I feel like looking at it. For now it allows you to register a listener with the on method and then emit data to the listener.

### Emitter
#### Sample Usage

```ruby

require './emitter'

emitter = Emitter.new

emitter.on :hello_world, lambda { |data| puts "1: #{data}" }


emitter.emit :hello_world, "Hello, brave Ruby World!"

```

The above code will result, when executed in a console, result in "1: "Hello, brave Ruby World!" being printed. Not a big deal but you can see the potential. A single instance of an Emitter can have any number of registered events and they will be chained, in the order they were registered. I can see some value in perhaps adding the ability to remove a listener from the chain but this isn't possible at the moment. A chain of listeners can be removed with the release method.

That's it for today. If anyone is interested in this and wants to chat, drop me a line. I imagine I'll get back to this soon in any event.

-Greg.

   
