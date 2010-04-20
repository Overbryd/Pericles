app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file

require 'spec/expectations'
require 'rack/test'
require 'webrat'

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{MyWorld.new}

root = File.join(Dir.tmpdir, rand(Time.now.to_i).to_f.to_s, 'pericles_cucumber_test')
FileUtils.mkdir_p File.join(root, 'user_configurations')
FileUtils.mkdir File.join(root, 'user_data')
Pericles.configure({
  :pwdfile => File.join(root, 'pwdfile'),
  :user_config_dir => File.join(root, 'user_configurations'),
  :user_data_dir => File.join(root, 'user_data'),
  :vsftp_uid => Process.uid,
  :vsftp_gid => Process.gid
})
at_exit do
  FileUtils.rm_r(root)
end