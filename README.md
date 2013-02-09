# Webdav storage for paperclip

Upload [Paperclip](https://github.com/thoughtbot/paperclip) attachments to a remote server via webdav.

## Installation

Add this line to your application's Gemfile:

    gem 'paperclip-webdav'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip-webdav

## Usage

#### In your rails model:

```ruby
class User < ActiveRecord::Base
  has_attached_file :avatar,

    # Choose the Webdav storage backend
    :storage => :webdav,

    # Set where to store the file on the Webdav server(s).
    # This supports Paperclip::Interpolations.
    :path => "/images/:attachment/:id/:style/:filename",
    
    # Hostname for generating links.
    :public_url => "http://cdn.example.com", # optional

    # The list of Webdav servers to use
    :webdav_servers => [
      {
        :url      => "http://webdav1.example.com",
        :username => "foo", # optional
        :password => "bar", # optional
      },
      # Add more servers if needed
      {
        :url      => "http://webdav1.example.com",
        :username => "foo", # optional
        :password => "bar"  # optional
      }
    ]
end
```

#### Or your config/application.rb (config/environments/*.rb):

```ruby
module YourApp
  class Application < Rails::Application
    # Other code...

    config.paperclip_defaults = {
      # Choose the Webdav storage backend
      :storage => :webdav,
      
      # Set where to store the file on the Webdav server(s).
      # This supports Paperclip::Interpolations.
      :path => "/images/:attachment/:id/:style/:filename",
      
      # Hostname for generating links.
      :public_url => "http://cdn.example.com", # optional
      
      # The list of Webdav servers to use
      :webdav_servers => [
        {
          :url      => "http://webdav1.example.com",
          :username => "foo", # optional
          :password => "bar", # optional
        },
        # Add more servers if needed
        {
          :url      => "http://webdav1.example.com",
          :username => "foo", # optional
          :password => "bar"  # optional
        }
      ]
    }
  end
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
