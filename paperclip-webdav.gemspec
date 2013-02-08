# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip-webdav/version'

Gem::Specification.new do |gem|
  gem.name          = "paperclip-webdav"
  gem.version       = Paperclip::Webdav::VERSION
  gem.authors       = ["Nikita Vorobej"]
  gem.email         = ["mail@gamersroom.ru"]
  gem.description   = %q{Webdav storage for paperclip}
  gem.summary       = %q{Webdav storage for paperclip}
  gem.homepage      = "https://github.com/Nikita-V/paperclip-webdav"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency "paperclip"
  gem.add_dependency "curb"
  
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard-rspec"
end
