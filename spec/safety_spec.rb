require 'rspec'
require 'safety'

describe Safety, " basic getters and setters for 'safe' declared attributes" do

  class Coordinate
    include Safety
    attr_accessor_Integer :x, 0
    attr_accessor_Integer :y, 0
    def initialize(x,y)
      self.x = x
      self.y = y
    end
  end
  
  class Test
    include Safety
    attr_accessor_String :notset
    attr_accessor_String :name, "Testing 1,2,3"

    attr_accessor_Coordinate :coordinate do
      Coordinate.new(self.count,self.greater_count)
    end
    attr_accessor_Integer :count do
      123
    end
    attr_accessor_Integer :greater_count do
      self.count + 1
    end    
    attr_accessor_var :not_type_safe, "pitbull"
  end
  
  it "should set the attribute with a default value and get the value back" do
    t = Test.new
    t.count.should eq(123)
  end

  it "should set the attribute with lazy instantiation and get the value back" do
    t = Test.new
    t.greater_count.should eq(124)
  end

  it "should set the attribute to a custom object with lazy instantiation and get an attribute of the value back" do
    t = Test.new
    t.coordinate.x.should eq(123)
    t.coordinate.y.should eq(124)
  end
  
  it "should set the attribute and get the value back" do
    t = Test.new
    hello = "hello"
    t.notset = hello
    t.notset.should eq(hello)
  end

  it "should throw an exception if reading an attribute that is not set" do
    expect {
      t = Test.new
      t.notset # BOMB!
    }.to raise_error(TypeError)
  end

  it "should throw an exception if setting an attribute to a value with a not matching type" do
    expect {
      t = Test.new
      t.count = "BOMB!"
    }.to raise_error(TypeError)
  end

  it "should not throw an exception if setting an attribute with the 'var' property to a different type" do
    t = Test.new
    t.not_type_safe.should eq("pitbull")
    t.not_type_safe = 2011
    t.not_type_safe.should eq(2011)
  end

  it "should have different instance variables" do
    t1 = Test.new
    t2 = Test.new
    t1.count.should eq(123)

    t2.count = 456

    t1.count.should eq(123)
    t2.count.should eq(456)
  end

  it "should not be setting variables on the singleton class" do
    expect {
      t = Test.new
      t.count = 666
      Test.count # BOMB!
    }.to raise_error(NoMethodError)
  end
end
