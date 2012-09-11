# About

The Mechanical MOOC is a simple web application to help with running online classes via mailing lists. It allows you to coordinate many groups of arbitrary size, giving each group it's own discussion mailing list. It accepts sign ups, stores relevant meta-data, and can collect survey-type information. There is no built-in functionality to place participants into groups but it does provide all of the mailing list configuration and management once users are added to groups.

# Requirements

* Understanding of Ruby, Sinatra, & DataMapper
* Heroku account
* Mailgun account

# Usage

1. Deploy the applicaiton on Heroku
2. Set the `MAILGUN_API_KEY` environment variable
3. Collect signups
4. Add users to groups from the console using whatever logic you like
5. Email the groups and watch the discussions happen

# Grouping Users

You can extend this application to automatically group users based on any criteria. Alternatively you can create groups manually at the ruby console.

In this example, we're splitting the users into groups of 10 based on the order that they signed up in:

```ruby
require './mooc'
Users.each_slice(10) do |ten_users|
  g = Group.new
  ten_users.each do |u|
    u.group = g
    u.save
  end
  g.save
end
```

# License

The Mechanical MOOC is available under the MIT License. Check out [LICENSE](/LICENSE) for more info.