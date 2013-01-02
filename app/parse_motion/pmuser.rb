class PMUser < PFUser

  def new
    self.user
  end

  # Subclass PMUser to define a modal.
  #
  # The fields username, password, & email are defined
  #   for you implicitly, but you can define them yourself
  #   for clarity as well.
  #
  # You /have to/ define the field for it's getter to work!!
  #
  # Example:
  #   class User < PMUser
  #     fields :username, :password, :full_name
  #   end

  # notes: need a special place for password; Parse doesn't ever let you retrieve it
  attr_accessor :passwrd

  def self.fields(*fields)
    fields.each do |f|
      if f != :password
        define_method(f.to_s) { self[f] }
        define_method(f.to_s + '=') { |val| self[f] = val }
      else
        define_method(f.to_s) { @passwrd }
        define_method(f.to_s + '=') do |val|
          self[f] = val
          @passwrd = val
        end
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
  attr_accessor :login_success_method, :login_failed_method

  def when(event, call:method)
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
    # if event == :signup_succeeds
    #   @signup_success_method = method
    # elsif event == :signup_fails
    #   @signup_failure_method = method
    # elsif event == :login_succeeds
    #   @login_success_method = method
    # elsif event == :login_fails
    #   @login_failure_method = method
    # end
  end

  def signup
    signUpInBackgroundWithBlock(lambda do |succeeded, error|
      if(!error)
        @delegate.send(:signup_success_method)
      else
        @delegate.send(:signup_error_method, error.userInfo[:error])
      end
    end)
  end

  def login
    if valid_credentials?
      self.logInWithUsernameInBackground(username, password:@passwrd,
        lambda do |user, error|
          @delegate.send
        end)
    end
  end

  def valid_credentials?
    valid = false

    if username.class != String || username.length <= 0
      print "\t => You need a (string) username to signup & login."
    elsif @passwrd.class != String || @passwrd.length <= 0
      print "\t => You need a (string) password to signup & login."
    else
      valid = true
    end

    valid
  end

end
