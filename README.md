# Ruby AsyncEmitter Class
## Abstract

[Link to the generated yard docs](http://htmlpreview.github.io/?https://raw.githubusercontent.com/softsprocket/emitter/master/doc/frames.html)

This is available as a gem as [async_emitter](https://rubygems.org/gems/async_emitter).

### AsyncEmitter
#### Sample Usage

```ruby
       emitter = AsyncEmitter.new
       emitter.on :error, lambda { |e| puts "Error: #{e}" }
       emitter.on :data, lambda { |data| puts "Data: #{data}" }

       begin
               data = get_data_from_somewhere
               emitter.emit :data, data
       rescue Exception => e
               emitter.emit :error, e
       end
```


   
