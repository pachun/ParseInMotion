class TestVC < UIViewController
  def viewDidLoad
    super

    user = XUser.new

    user.delegate = self
    user.when :signup_succeeds, 'signed_up'
    user.when :signup_fails, 'signup_failed:'
    user.when :login_succeeds, 'logged_in:'
    user.when :login_fails, 'login_failed:'

    user.username = 'pachun'
    user.password = 'password'
    user.email = 'hello@nickpachulski.com'
    user.full_name = 'Kris Kringal'

    # puts "username: #{user.username}\npassword: #{user.password}\nemail: #{user.email}\nfull_name: #{user.full_name}"
    XUser.login(user)
  end

  def signed_up
    puts 'signed up!!'
  end

  def signup_failed(error)
    puts "signup failed with: #{error}"
  end

  def logged_in(user)
    puts "logged in!!"
  end

  def login_failed(error)
    puts "login failed: #{error}"
  end
end

class XUser < PMUser
  fields :username, :password, :email, :full_name

  def greet
    puts 'hello'
  end
end
