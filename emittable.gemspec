Gem::Specification.new do |s|
  s.name        = 'emittable'
  s.version     = '0.1.1'
  s.date        = '2018-04-26'
  s.summary     = 'Event registering and triggering.'
  s.description = 'A simple event registering/triggering module to mix into classes.'
  s.authors     = 'Rob Fors'
  s.email       = 'mail@robfors.com'  
  s.files       = Dir.glob("{lib,spec}/**/*") + %w(LICENSE README.md)
  s.homepage    = 'https://github.com/robfors/emittable'
  s.license     = 'MIT'
end
