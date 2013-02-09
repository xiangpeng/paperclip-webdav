require "spec_helper"

describe Paperclip::Storage::Webdav::Server do
  let(:response) { double() }
  let(:image_path) { "/files/image.png" }
  let(:host) { "http://example.com" }
  let(:server) { Paperclip::Storage::Webdav::Server.new :url => host }
  let(:server_with_auth) do
    credentials = {}
    credentials[:url] = host
    credentials[:username] = "username"
    credentials[:password] = "password"
    Paperclip::Storage::Webdav::Server.new credentials    
  end
  
  describe "file_exists?" do
    it "should returns true if (200 <= status_code < 210)" do
      response.stub(:response_code).and_return(200)
      Curl::Easy.should_receive(:http_head).and_return(response)
      server.file_exists?(image_path).should be_true
    end
    
    it "should returns false if status_code != 200..209" do
      response.stub(:response_code).and_return(404)
      Curl::Easy.should_receive(:http_head).and_return(response)
      server.file_exists?(image_path).should be_false
    end
  end
  
  describe "auth" do
    let(:curl_object) do
      curl = double()
      curl.stub(:username=)
      curl.stub(:password=)
      curl
    end
    
    it "save auth credentials into curl object" do
      curl_object.should_receive(:username=).with("username")
      curl_object.should_receive(:password=).with("password")
      server_with_auth.instance_variable_set(:@curl_object, curl_object)
      server_with_auth.instance_eval do
        auth @curl_object
      end
    end
    
  end
  
  describe "full_url" do
    it "full_url should returns correct url" do
      server.instance_variable_set(:@image_path, image_path)
      server.instance_variable_set(:@host, host)
      server.instance_eval do
        should_receive(:full_url).with(@image_path).and_return("#{@host}#{@image_path}")
        full_url @image_path
      end
    end
  end
end
