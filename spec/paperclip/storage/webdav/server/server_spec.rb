require "spec_helper"

describe Paperclip::Storage::Webdav::Server do
  let(:server) { Paperclip::Storage::Webdav::Server.new "http://example.com" }
  
  describe "file_exists?" do
    let(:response) { double() }
    
    it "should returns true if (200 <= status_code < 210)" do
      response.stub(:response_code).and_return(200)
      Curl::Easy.should_receive(:http_head).and_return(response)
      server.file_exists?("/files/image.png").should be_true
    end
    
    it "should returns false if status_code != 200..210" do
      response.stub(:response_code).and_return(404)
      Curl::Easy.should_receive(:http_head).and_return(response)
      server.file_exists?("/files/image.png").should be_false
    end
  end
  
  describe "full_url" do
    it "full_url should returns correct url" do
      server.instance_eval do
        should_receive(:full_url).with("/files/image.png").and_return("http://example.com/files/image.png")
        full_url "/files/image.png"
      end
    end
  end
end
