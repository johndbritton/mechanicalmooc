require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class User
  include DataMapper::Resource

  belongs_to :group, :required => false

  property :id, Serial
  property :email, String, :required => true
  property :group_work, Boolean, :default => true
  property :learning_style, String
  property :timezone, String
  property :image, String

  property :created_at, DateTime
  property :updated_at, DateTime

  validates_uniqueness_of :email
  validates_format_of :email, :as => :email_address
end

class Group
  include DataMapper::Resource

  has n, :users

  property :id, Serial

  property :created_at, DateTime
  property :updated_at, DateTime
end

DataMapper.finalize
DataMapper.auto_migrate!

post '/signup' do
  User.create(
    :email => params[:email],
    :group_work => params[:groupRadios],
    :learning_style => params[:styleRadios],
    :timezone => params[:timezone],
    :image => params[:imageRadios]
  )
  "Thanks for signing up, we'll email you soon."
end

post '/parse' do
  "400 OK"
end