class DemosController < ApplicationController
  def new
    # Optional: setting session[:demo_db] to nil will reset the demo
    session[:demo_db] = nil
  end

  def create
    # copy master 'demo' database
    master_db = default_demo_database
    demo_db = "demo_database_#{Time.now.to_i}_#{SecureRandom.base64.tr("+/", "360")[0..3]}"
    ActiveRecord::Base.connection.execute('CREATE DATABASE demo_database_001 WITH TEMPLATE demo_template OWNER uwof48;')

    # set session for new db
    session[:demo_db] = demo_db

    # Optional: login code (if applicable)
    # add your own login code or method here
    # login_user(User.first)
    session[:user_id] = User.first.id

    redirect_to root_url
  end

end
