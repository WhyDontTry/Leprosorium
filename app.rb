#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


before do
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

get '/' do
	erb "Yo man! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
	erb :new
end

post '/new' do
	@content = params[:content]
	erb "<h2>Ha ha, classic...</h2><br><h3>You typed: #{@content}</h3> "
end

get '/main' do

end