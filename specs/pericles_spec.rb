require File.dirname(__FILE__) + '/spec_helper'

describe Pericles do
  before :each do
    FileUtils.rm_r(tmpdir)
    Pericles.configure({
      :pwdfile => File.join(tmpdir, 'pwdfile'),
      :user_config_dir => File.join(tmpdir, 'user_configurations'),
      :user_data_dir => File.join(tmpdir, 'user_data'),
      :vsftp_uid => Process.uid,
      :vsftp_gid => Process.gid
    })
    FileUtils.mkdir Pericles.config.user_config_dir
    FileUtils.stub(:chown)
  end
  
  describe "add" do
    it "should add an entry to the pwdfile" do
      Pericles.add('john', 'smith')
      File.read(Pericles.pwdfile).should match(/john:(.*)/)
    end
    
    it "should create a separate directory for the new user" do
      FileUtils.should_receive(:chown).with(Pericles.config.vsftp_uid.to_s, Pericles.config.vsftp_gid.to_s, Pericles.user_data_dir('john'))
      Pericles.add('john', 'smith')
      File.directory?(Pericles.user_data_dir('john')).should be_true
    end
    
    it "should create an empty user specific configuration file" do
      Pericles.add('john', 'smith')
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