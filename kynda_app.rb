require 'sinatra'

get '/' do
	erb :index
end

get '/about' do
	erb :about
end

get '/clippings_upload' do
	erb :clippings_upload
end