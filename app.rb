# frozen_string_literal: true
require "sqlite3"

class App < Sinatra::Base

  def db
    if @db == nil
      @db = SQLite3::Database.new "db/db.sqlite"
      @db.results_as_hash = true
    end
    return @db
  end

  get '/' do
    @title = "Home"
    erb :index
  end
  # fruits # index
  get '/fruits' do
    @title = "Fruits"
    @fruits = db.execute('SELECT * FROM fruits')
    erb :'fruits/index'
  end

  get '/fruits/new' do
    erb :'fruits/new'
  end

  get '/fruits/:id' do
    @fruit = db.execute('SELECT * FROM fruits WHERE id = ?', params[:id]).first
    @title = @fruit["name"]
    erb :'fruits/show'
  end

  post '/fruits' do
    name = params["fruit"]
    description = params["description"]
    query = 'INSERT INTO fruits (name, description) VALUES (?,?) RETURNING id'
    result = db.execute(query, name, description).first
    redirect "/fruits/#{result["id"]}"
  end
end