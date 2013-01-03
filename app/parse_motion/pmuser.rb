class PMUser < PFUser

  def new
    self.user
  end

  # Subclass PMUser to define a modal.
  #
  # The fields username, password, & email are defined
  #   for you implicitly, but you can define them yourself
  #   in the model definition for clarity as well.
  #
  # Example:
  #   class User < PMUser
  #     fields :username, :password, :full_name
  #   end

  attr_accessor :fields

  def self.fields(*fields)
    @fields = []
    fields.each do |f|
      f = f.to_sym
      @fields << f
      if f != :username && f != :email && f != :password
        define_method(f.to_s) { self[f] }
        define_method(f.to_s + '=') { |val| self[f] = val }
      end
    end
  end

  # @delegate is the object all user callbacks will be sent
  #   to.
  #
  # Use PMUser#when( {:signup|:login}_{succeeds|fails}, call:method)
  #   to set the methods to call on that object for
  #   login & signup success & failure.

  attr_accessor :delegate
  attr_accessor :signup_success_method, :signup_failure_method
  attr_accessor :login_success_method, :login_failure_method

  def when(event, method)
    method = method.to_sym
    case(event)
    when :signup_succeeds
      @signup_success_method = method
    when :login_succeeds
      @login_success_method = method
    when :signup_fails
      @signup_failure_method = method
    when :login_fails
      @login_failure_method = method
    else
      puts "\"#{event}\" is not an understood event."
    end
  end

  def signup
    signUpInBackgroundWithBlock(lambda do |succeeded, error|
      if(!error)
        @delegate.send(@signup_success_method)
      else
        @delegate.send(@signup_failure_method, error.userInfo[:error])
      end
    end)
  end

  def self.login(user)
    if user.valid_credentials?
      PFUser.logInWithUsernameInBackground(user.username, password:user.password, block:lambda do |authed_user, error|
        if (authed_user)
          # puts "all methods: #{user.class.instance_methods(false)}"
          # add instance methods to authed_user here
          user.delegate.send(user.login_success_method, authed_user)
        else
          user.delegate.send(user.login_failure_method, error.userInfo[:error])
        end
      end)
    end
  end

  def valid_credentials?
    valid = false
    if username.class != String || username.length <= 0
      print "\t => You need a (string) username to signup & login."
    elsif password.class != String || password.length <= 0
      print "\t => You need a (string) password to signup & login."
    else
      valid = true
    end
    valid
  end

  def self.logout
    PFUser.logOut
  end

  def self.current
    PFUser.currentUser
  end
end
