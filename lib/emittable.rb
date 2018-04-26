require 'emittable/error'


module Emittable

  def initialize(*args)
    @emittable_setup = true
    @emittable_events = {}
    @emittable_mutex = Mutex.new
    super
  end
  
  # Register a handler for the given event name.
  #
  #   obj.on(:foo) { puts "foo was called" }
  #
  # @param [String, Symbol] name event name
  # @return handler
  def on(event_name, &callback)
    raise ArgumentError, "event name must respond to 'to_s'" unless event_name.respond_to?(:to_s)
    event_name = event_name.to_s
    @emittable_mutex.synchronize do
      @emittable_events[event_name] ||= []
      callbacks = @emittable_events[event_name]
      callbacks << callback
    end
    nil
  end
  
  def off(event_name, callback)
    raise ArgumentError, "event name must respond to 'to_s'" unless event_name.respond_to?(:to_s)
    event_name = event_name.to_s
    @emittable_mutex.synchronize do
      callbacks = @emittable_events[event_name]
      raise Error, 'no callbacks found for that event' unless callbacks
      raise Error, 'callback not found' unless callbacks.include?(callback)
      callbacks.delete(callback)
      @emittable_events.delete(event_name) if callbacks.empty?
    end
    nil
  end
  
  # Trigger the given event name and passes all args to each handler
  # for this event.
  #
  #   obj.trigger(:foo)
  #   obj.trigger(:foo, 1, 2, 3)
  #
  # @param [String, Symbol] name event name to trigger
  def trigger(event_name, *args)
    raise ArgumentError, "event name must respond to 'to_s'" unless event_name.respond_to?(:to_s)
    event_name = event_name.to_s
    callbacks = nil
    @emittable_mutex.synchronize do
      callbacks = @emittable_events[event_name]
      raise Error, 'no callbacks found for that event' unless callbacks
      callbacks = callbacks.dup
    end
    # we are outside of the mutex so any callbacks are able to trigger an event from
    #  this class without deadlock
    callbacks.each { |callback| callback.call(*args) }
    nil
  end
  
  private
  
  def check_emittable_setup
    raise Error, "has 'super' been called on including class?" unless @emittable_setup
    nil
  end
  
end
