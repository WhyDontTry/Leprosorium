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
				"content" TEXT,
				"autor" TEXT
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
	autor = params[:autor]

	errors = {
		:content => "Type the text",
		:autor => "Type autor's name"
	}

	params.each do |key, value|
		if value.length <= 0
			@error = errors[key]
			return erb :new
		end
	end

	@db.execute 'INSERT INTO Posts (content, created_date, autor) VALUES (?, datetime(), ?)', [@content, autor]

	redirect to '/'
end

get '/main' do

end

get '/details/:id' do
	post_id = params[:id]

	results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'SELECT * FROM Comments 
					WHERE post_id = ? ORDER BY id', [post_id]

	erb :details
end

post '/details/:id' do
	post_id = params[:id]
	content = params[:content]

	if content.length <= 0
		@error = "Type the comment"
		redirect to('/details/'.concat post_id)
	end

	@db.execute 'INSERT INTO Comments 
		(
			content, 
			created_date, 
			post_id
		) VALUES (?, datetime(), ?)', [content, post_id]

	redirect to('/details/'.concat post_id)
end