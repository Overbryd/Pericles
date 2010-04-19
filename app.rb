require 'rubygems'
require 'sinatra'
require 'haml'

require 'lib/pericles'

Pericles.configure({
  :pwdfile => File.join(File.dirname(__FILE__), 'vsftp', 'pwdfile'),
  :user_config_dir => File.join(File.dirname(__FILE__), 'vsftp', 'user_configurations'),
  :user_data_dir => File.join(File.dirname(__FILE__), 'vsftp', 'user_data')
})

get '/' do
  @names = Pericles.names
  haml :index
end

get '/users/new' do
  haml :new
end

post '/users' do
  if Pericles.names.include?(params[:name])
    error 400, "User already exists"
  else
    Pericles.add(params[:name], params[:password])
  end
  redirect '/'
end

delete '/users' do
  Pericles.destroy(params[:name])
  redirect '/'
end