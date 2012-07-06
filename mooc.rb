require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'
require 'rest_client'

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
  
  after :create, :send_welcome_email
  
  def send_welcome_email
    RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}"\
    "@api.mailgun.net/v2/mooc.mailgun.org/messages",
    :from => "The Machine <the-machine@mooc.mailgun.org>",
    :to => email,
    :subject => "Hello",
    :text => "Thanks for signing up"
  end
end

class Group
  include DataMapper::Resource

  has n, :users

  property :id, Serial

  property :created_at, DateTime
  property :updated_at, DateTime
  
  after :create, :start_list
  after :save, :upsert_list_members

  def start_list
    RestClient.post("https://api:#{ENV['MAILGUN_API_KEY']}" \
                      "@api.mailgun.net/v2/lists",
                      :address => list_address)
    RestClient.post("https://api:#{ENV['MAILGUN_API_KEY']}" \
                    "@api.mailgun.net/v2/lists/#{list_address}/members",
                    :address => "the-machine@mooc.mailgun.org",
                    :upsert => 'yes')
  end
  
  def upsert_list_members
    users.each do |u|
      RestClient.post("https://api:#{ENV['MAILGUN_API_KEY']}" \
                      "@api.mailgun.net/v2/lists/#{list_address}/members",
                      :address => u.email,
                      :upsert => 'yes')
    end
  end
  
  def list_address
    "python-#{id}@mooc.mailgun.org"
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!

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