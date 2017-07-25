class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  before_filter :set_demo_database


  def current_user
    return User.find_by(id: session[:user_id])
  end

  def login_required
    if !current_user
      redirect_to login_path, notice: 'Login is required'
    end
  end

  private

    # sets the database for the demo environment
    def set_demo_database
      # method only necessary for 'demo' environment
      if Rails.env == 'demo'

        if session[:demo_db]
          db_name = session[:demo_db]
        else
          # Use default 'demo' database
          db_name = default_demo_database
        end

        ActiveRecord::Base.establish_connection(demo_connection(db_name))
      end
    end

    # Returns the current database configuration hash
    def default_connection
      @default_config ||= ActiveRecord::Base.connection.instance_variable_get("@config").dup
    end

    # Returns the connection hash but with database name changed
    # The argument should be a path
    def demo_connection(db_path)
      default_connection.dup.update(:database => db_path)
    end

    # Returns the default demo database path defined in config/database.yml
    def default_demo_database
      return YAML.load_file("#{Rails.root.to_s}/config/database.yml")['demo']['database']
    end



end
