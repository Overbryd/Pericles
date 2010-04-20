require 'rubygems'
require 'sinatra'
require 'haml'

require 'lib/pericles'

Pericles.configure({
  :pwdfile => '/etc/vsftpd/pwdfile',
  :user_config_dir => '/etc/vsftpd/users',
  :user_data_dir => '/home/vsftpd',
  :vsftp_uid => 251,
  :vsftp_gid => 251
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