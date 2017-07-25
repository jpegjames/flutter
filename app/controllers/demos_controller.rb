class DemosController < ApplicationController
  def new
    # Optional: setting session[:demo_db] to nil will reset the demo
    session[:demo_db] = nil
  end

  def create
    # database names
    template_demo_db = default_demo_database
    new_demo_db = "demo_database_#{Time.now.to_i}"

    # Create database using Admin credentials
    `mysqladmin -u#{ ENV['DB_ADMIN'] } -p#{ ENV['DB_ADMIN_PASSWORD'] } create #{new_demo_db}`

    # Load template sql into new database
    `mysql -u#{ ENV['DB_ADMIN'] } -p#{ ENV['DB_ADMIN_PASSWORD'] } #{new_demo_db} < db/demo_template.sql`

    # Grant access to App user (if applicable)
    `mysql -u#{ ENV['DB_ADMIN'] } -p#{ ENV['DB_ADMIN_PASSWORD'] } -e "GRANT ALL on #{new_demo_db}.* TO '#{ ENV['DB_USERNAME'] }'@'%';"`

    # set session for new db
    session[:demo_db] = new_demo_db

    # Optional: login code (if applicable)
    # add your own login code or method here
    # login_user(User.first)
    session[:user_id] = User.first.id

    redirect_to root_url
  end

end
