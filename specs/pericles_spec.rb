require File.dirname(__FILE__) + '/spec_helper'

describe Pericles do
  before :each do
    FileUtils.rm_r(tmpdir)
    Pericles.configure({
      :pwdfile => File.join(tmpdir, 'pwdfile'),
      :user_config_dir => File.join(tmpdir, 'user_configurations'),
      :user_data_dir => File.join(tmpdir, 'user_data')
    })
    FileUtils.mkdir Pericles.config.user_config_dir
  end
  
  describe "add" do
    before :each do
      Pericles.add('john', 'smith')
    end
    
    it "should add an entry to the pwdfile" do
      File.read(Pericles.pwdfile).should match(/john:(.*)/)
    end
    
    it "should create a separate directory for new user" do
      File.directory?(Pericles.user_data_dir('john')).should be_true
    end
    
    it "should create an empty user specific configuration file" do
      File.exist?(Pericles.user_config('john')).should be_true
    end
  end
  
  describe "destroy" do
    before :each do
      Pericles.add('john', 'smith')
    end
    
    it "should delete the entry from the pwdfile" do
      Pericles.destroy('john')
      File.read(Pericles.pwdfile).should_not include('john')
    end
    
    it "should recursively delete the users directory" do
      Pericles.destroy('john')
      File.directory?(Pericles.user_data_dir('john')).should be_false
    end
    
    it "should delete the user configuration file" do
      Pericles.destroy('john')
      File.exist?(Pericles.user_config('john')).should be_false
    end
  end
end