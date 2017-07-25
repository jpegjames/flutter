class DemosController < ApplicationController
  before_filter :reset_demo_database, only: [:new]
  skip_before_filter :set_demo_database, only: [:new]

  def new
    # Optional: setting session[:demo_db] to nil will reset the demo
    session[:demo_db] = nil
  end

  def create
    # copy master 'demo' database
    template_demo_db = default_demo_database
    new_demo_db = "demo_database_#{Time.now.to_i}".downcase # PG databases are case senstive but created lowercase by default
    ActiveRecord::Base.connection.execute("CREATE DATABASE #{ new_demo_db } WITH TEMPLATE #{ template_demo_db } OWNER uxkfu2;")

    # set session for new db
    session[:demo_db] = new_demo_db

    # Optional: login code (if applicable)
    # add your own login code or method here
    # login_user(User.first)
    session[:user_id] = User.first.id

    redirect_to root_url
  end

end
