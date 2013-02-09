require 'uri'

module Paperclip
  module Storage
    module Webdav
      class Server
        def initialize credentials
          @url = credentials[:url]
          @username = credentials[:username]
          @password = credentials[:password]
        end
        
        def file_exists? path
          response = Curl::Easy.http_head full_url(path)
          response.response_code >= 200 && response.response_code <= 209
        end
        
        def get_file remote_file_path, local_file_path
          Curl::Easy.download full_url(remote_file_path), local_file_path
        end
        
        def put_file path, file
          Curl::Easy.http_put full_url(path), file, &method(:auth)
        end
        
        def delete_file path
          Curl::Easy.http_delete full_url(path), &method(:auth)
        end
        
        private
        def auth curl
          curl.username = @username unless @username.nil?
          curl.password = @password unless @password.nil?
        end
        
        def full_url path
          URI.join(@url, path).to_s
        end
      end
    end
  end
end
