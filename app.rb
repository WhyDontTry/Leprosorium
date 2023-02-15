#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'


set :database, {adapter: 'sqlite3', database: 'leprosorium.db'}


class Post < ActiveRecord::Base
	validates :content, :presence => true
	validates :autor, 	:presence => true
end

class Comment < ActiveRecord::Base
	validates :content, :presence => true
end



get '/' do

	@posts = Post.order('created_at DESC')

	erb :index			
end

get '/new' do
	erb :new
end

post '/new' do
	post = Post.new params[:post]
	
	post.save


	redirect to '/'
end

get '/main' do

end

get '/details/:id' do
	post_id = params[:id]

	@post = Post.where(id: post_id)
	@post = @post.first

	@comments = Comment.where(post_id: post_id).order(created_at: :desc)

	erb :details
end

post '/details/:id' do
	post_id = params[:id]
	content = params[:content]


	comment = Comment.new(post_id: post_id, content: content)
	comment.save

	redirect to('/details/'.concat post_id)
end