class DemosController < ApplicationController
  def new
    # Optional: setting session[:demo_db] to nil will reset the demo
    session[:demo_db] = nil
  end

  def create
    # make db/demos dir if doesn't exist
    unless File.directory?('db/demos/')
      FileUtils.mkdir('db/demos/')
    end

    # copy master 'demo' database
    master_db = default_demo_database
    demo_db = "db/demos/demo-#{Time.now.to_i}-#{SecureRandom.base64.tr("+/", "360")[0..8]}.sqlite3"
    FileUtils::cp master_db, demo_db

    # set session for new db
    session[:demo_db] = demo_db

    # Optional: login code (if applicable)
    # add your own login code or method here
    # login_user(User.first)
    session[:user_id] = User.first.id

    redirect_to root_url
  end

end
