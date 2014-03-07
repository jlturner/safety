Gem::Specification.new do |s|
  s.name        = 'safety'
  s.version     = '1.0.0'
  s.date        = '2014-03-06'
  s.summary     = "Type Safety in Ruby"
  s.description = "Allows you to create type safe attributes in Ruby. Attributes may also have default values or lazy instantiators"
  s.authors     = ["James Lawrence Turner"]
  s.email       = 'james@jameslawrenceturner.com'
  s.files       = ["lib/safety.rb",
                   "lib/safety/safety_module.rb",
                   "lib/safety/safety_attribute_helper.rb"]
  s.homepage    = 'http://github.com/jlturner/safety'
  s.license     = 'MIT'
end