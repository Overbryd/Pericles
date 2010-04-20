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
    
    it "should escape crazy input" do
      Pericles.add('johnny', %q{!&'"`$0 |()<>})
      Pericles.names.should include('johnny')
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
    
    it "should delete the user configuration file" do
      Pericles.destroy('john')
      File.exist?(Pericles.user_config('john')).should be_false
    end
  end
  
  describe "validation" do
    it "should have valid name" do
      Pericles.valid_name?('').should be_false
      Pericles.valid_name?(' ').should be_false
      Pericles.valid_name?('%\#$!@#4').should be_false
      Pericles.valid_name?('peterjohn').should be_true
    end
    
    it "should have valid password" do
      Pericles.valid_password?('').should be_false
      Pericles.valid_password?(' ').should be_false
      Pericles.valid_password?('peter').should be_false
      Pericles.valid_password?('%\#$!@#4').should be_true
      Pericles.valid_password?('peterjohn').should be_true
    end
  end
end