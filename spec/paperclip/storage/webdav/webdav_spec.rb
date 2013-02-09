require "spec_helper"

describe Paperclip::Storage::Webdav do
  [:attachment, :attachment_with_public_url].each do |attachment|
    let(attachment) do
      model = double()
      model.stub(:id).and_return(1)
      model.stub(:image_file_name).and_return("image.png")
      
      options = {}
      options[:storage] = :webdav
      options[:path] = "/files/:style/:filename"
      options[:webdav_servers] = ["http://webdav1.example.com", "http://webdav2.example.com"]
      options[:public_url] = "http://public.example.com" if attachment == :attachment_with_public_url
      
      attachment = Paperclip::Attachment.new(:image, model, options)
    end
  end
  
  describe "generate public url" do
    [:attachment, :attachment_with_public_url].each do |a|
      context a do
        [:original, :thumb].each do |style|
          it "with #{style} style" do
            attachment.instance_eval do
              host = ""
              if a == :attachment
                host = "http://webdav1.example.com"
              else
                host = "http://public.example.com"
              end
              should_receive(:public_url).and_return("#{host}/files/#{style}/image.png")
              public_url style
            end
          end
        end
      end
    end
  end
  
  describe "exists?" do
    it "should returns false if original_name not set" do
      attachment.stub(:original_filename).and_return(nil)
      attachment.exists?.should be_false
    end
    
    it "should returns true if file exists on the primary server" do
      attachment.instance_eval do
        primary_server.should_receive(:file_exists?).with("/files/original/image.png").and_return(true)
      end
      attachment.exists?.should be_true
    end
    
    it "accepts an optional style_name parameter to build the correct file pat" do
      attachment.instance_eval do
        primary_server.should_receive(:file_exists?).with("/files/thumb/image.png").and_return(true)
      end
      attachment.exists?(:thumb).should be_true
    end
  end
  
  describe "flush_writes" do    
    it "store all files on each server" do
      original_file = double("file")
      thumb_file = double("file")
      attachment.instance_variable_set(:@queued_for_write, {
        :original => double("file"),
        :thumb    => double("file")
      })
      
      attachment.instance_eval do
        @queued_for_write.each do |k,v|
          v.should_receive(:rewind)
        end
        
        servers.each do |server|
          server.should_receive(:put_file).with("/files/original/image.png", @queued_for_write[:original])
          server.should_receive(:put_file).with("/files/thumb/image.png", @queued_for_write[:thumb])
        end
      end
      attachment.should_receive(:after_flush_writes).with(no_args)
      attachment.flush_writes
      attachment.queued_for_write.should eq({})      
    end
  end
  
  describe "flush_deletes" do
    it "deletes files on each servers" do
      attachment.instance_variable_set(:@queued_for_delete, [
        "/files/original/image.png",
        "/files/thumb/image.png"
      ])
      attachment.instance_eval do
        servers.each do |server|
          server.should_receive(:delete_file).with(@queued_for_delete.first)
          server.should_receive(:delete_file).with(@queued_for_delete.last)
        end
      end
      attachment.flush_deletes
      attachment.instance_variable_get(:@queued_for_delete).should eq([])
    end
  end
  
  describe "copy_to_local_file" do
    it "save file" do
      attachment.instance_eval do
        primary_server.should_receive(:get_file).with("/files/original/image.png", "/local").and_return(nil)
      end
      attachment.copy_to_local_file(:original, "/local")
    end
    
    it "save file with custom style" do
      attachment.instance_eval do
        primary_server.should_receive(:get_file).with("/files/thumb/image.png", "/local").and_return(nil)
      end
      attachment.copy_to_local_file(:thumb, "/local")
    end
  end
end
