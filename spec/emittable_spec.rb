require 'emittable'

RSpec.describe Emittable do
  
  before do
    RSpec::Mocks.with_temporary_scope do
      stub_const 'A', Class.new
      A.class_eval{ include Emittable }
      @a = A.new
    end
  end
  
  describe "#on" do
  
    context "when adding a callback" do
      it "should not raise error" do
        expect{ @a.on(:event) {} }.not_to raise_error
      end
    end
    
    context "when adding a second callback for same event" do
      it "should not raise error" do
        @a.on(:event) {}
        expect{ @a.on(:event) {} }.not_to raise_error
      end
    end
    
  end
  
  describe "#trigger" do
  
    context "when triggering an event" do
      it "should invoke all callbacks" do
        $test = []
        @a.on(:event) { $test << nil }
        @a.on(:event) { $test << nil }
        @a.trigger(:event)
        expect($test.length).to eql 2
      end
    end
    
    context "when triggering an event with arguments" do
      it "should invoke all callback with arguments" do
        @a.on(:event) { |arg| $test = arg }
        @a.trigger(:event, 1)
        expect($test).to eql 1
      end
    end
    
  end
  
  describe "#off" do
  
    context "when removing an existing callback" do
      it "should not raise error" do
        callback = proc {}
        @a.on(:event, &callback)
        @a.trigger(:event)
        expect{ @a.off(:event, callback) }.not_to raise_error
      end
    end
    
    context "after removing a callback" do
      it "should sould raise error" do
        callback = proc {}
        @a.on(:event, &callback)
        @a.trigger(:event)
        @a.off(:event, callback)
        expect{ @a.trigger(:event) }.to raise_error(Emittable::Error)
      end
    end
    
  end
  
end
