class DemosController < ApplicationController
  def new
    # Optional: setting session[:demo_db] to nil will reset the demo
    session[:demo_db] = nil
  end

  def create
    # copy master 'demo' database
    template_demo_db = default_demo_database
    new_demo_db = "demo_database_#{Time.now.to_i}".downcase # PG databases are case senstive but created lowercase by default

    # ActiveRecord::Base.connection.execute("SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '#{template_demo_db}' AND pid <> pg_backend_pid();")
    # ActiveRecord::Base.connection.execute("CREATE DATABASE #{ new_demo_db } WITH TEMPLATE #{ template_demo_db } OWNER uxkfu2;")

    # Create database using system() method (returns true if shell command succeeds)
    # mysqladmin -u[db_admin] -p[db_password] create [new_db_name]
    system("mysqladmin -u#{ ENV['DB_ADMIN'] } -p#{ ENV['DB_ADMIN_PASSWORD'] } create #{new_demo_db}")

    # Load template sql (returns true if shell command succeeds)
    # mysql -u[db_admin] -p[db_password] [new_db_name]
    system("mysql -u#{ ENV['DB_ADMIN'] } -p#{ ENV['DB_ADMIN_PASSWORD'] } #{new_demo_db} < db/demo_template.sql")

    # Load template sql (returns true if shell command succeeds)
    # 
    system("mysql -u#{ ENV['DB_ADMIN'] } -p#{ ENV['DB_ADMIN_PASSWORD'] } -e \"GRANT ALL on #{new_demo_db}.* TO '#{ ENV['DB_USERNAME'] }'@'%';\"")

    # set session for new db
    session[:demo_db] = new_demo_db

    # Optional: login code (if applicable)
    # add your own login code or method here
    # login_user(User.first)
    session[:user_id] = User.first.id

    redirect_to root_url
  end

end
