# Emittable
A Ruby Gem to register and trigger events. It is a clone of `Vienna::Emittable`. It is thread safe.

# Install
`gem install emittable`

# Example
First `require 'emittable'` in your project. Then you can `include` `Emittable` in your classes. If you override `initialize` remember to call `super`.
```ruby
require 'emittable'

class A
  include Emittable
  
  def initialize(...)
    super
    ...
  end
  
  ...
  ...
  
end

a = A.new(...)
```

To register a new event callback call `on` on an instance of your class, passing the name of the event and a block as the callback. You can add as many callbacks as you want for an event.
```ruby
a.on(:shutdown) do
  ...
end

a.on(:shutdown) do
  ...
  ...
end
```

To trigger all the event's callbacks call `trigger`, passing the name of the event.
```ruby
a.trigger(:shutdown)
```

You can also pass arguments to `trigger` that will get passed to a callback block.
```ruby
a.on(:shutdown) do |a, b|
  ...
end

a.trigger(:shutdown, 1, 2)
```

To remove a callback you must have already saved a reference to the callback block. You can then call `off`, passing the block.
```ruby
callback = proc { ... }

a.on(:shutdown, &callback)

a.off(:shutdown, callback)
```
