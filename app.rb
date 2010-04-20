require 'rubygems'
require 'sinatra'
require 'haml'

require 'lib/pericles'

Pericles.configure({
  :pwdfile => File.join(File.dirname(__FILE__), 'vsftp', 'pwdfile'),
  :user_config_dir => File.join(File.dirname(__FILE__), 'vsftp', 'user_configurations'),
  :user_data_dir => File.join(File.dirname(__FILE__), 'vsftp', 'user_data')
})

use Rack::Auth::Basic do |username, password|
  [username, password] == ['ftpadmin', 'ASfeir234234sawFwasdf']
end

get '/' do
  redirect '/users'
end

get '/users' do
  @names = Pericles.names
  haml :index
end

get '/users/new' do
  haml :new
end

post '/users' do
  if Pericles.names.include?(params[:name]) || !Pericles.valid_name?(params[:name]) || !Pericles.valid_password?(params[:password])
    haml :error
  else
    Pericles.add(params[:name], params[:password])
    redirect '/'
  end
end

delete '/users' do
  Pericles.destroy(params[:name])
  redirect '/'
end