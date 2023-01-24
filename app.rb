#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db

	@db.execute 'CREATE TABLE IF NOT EXISTS
			"Posts"
			(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"created_date" DATE,
				"content" TEXT
			)'

	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Comments"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"created_date" DATE,
			"content" TEXT,
			"post_id" INTEGER
		)'
end


get '/' do

	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'

	erb :index			
end

get '/new' do
	erb :new
end

post '/new' do
	@content = params[:content]

	if @content.length <= 0
		@error = "Type text"
		return erb :new
	end

	@db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [@content]

	redirect to '/'
end

get '/main' do

end

get '/details/:id' do
	post_id = params[:id]

	results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
	@row = results[0]

	erb :details
end

post '/details/:id' do
	post_id = params[:id]
	content = params[:content]

	erb "You typed comment #{content} for post #{post_id}"
end