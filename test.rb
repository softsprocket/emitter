#!/usr/bin/ruby

require './emitter'

emitter = Emitter.new

emitter.on :hello_world, lambda { |data| puts "1: #{data}" }
emitter.on :hello_world, lambda { |data| puts "2: #{data}" }

emitter.once :hello_world, lambda { |data| puts "5: #{data}" }

emitter.on :goodbye_world, lambda { |data| puts "3: #{data}" }
emitter.on :goodbye_world, lambda { |data| puts "4: #{data}" }


emitter.emit :hello_world, "Hello, brave Ruby World!"

emitter.emit :hello_world, "Hello, 1"
emitter.emit :hello_world, "Hello, 2"
emitter.emit :hello_world, "Hello, 3"

emitter.emit :goodbye_world, "Goodbye, brave Ruby World!"

sleep 1

emitter.release :hello_world
emitter.release :goodbye_world


