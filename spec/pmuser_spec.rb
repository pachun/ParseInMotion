describe 'The Parse Motion User Class' do

  it 'should instantiate a new User object correctly' do
    user = PMUser.new
    user.class.should == PMUser
  end

  it 'should inherit setters for username, email, & password' do
    user = PMUser.new
    user.username = 'pachun'.should == 'pachun'
    user.email = 'hello@nickpachulski.com'.should == 'hello@nickpachulski.com'
    user.password = 'password1234'.should == 'password1234'
  end

  it 'should add setters & getters for user specified fields' do
    class User < PMUser
      fields :full_name
    end

    user1 = User.new
    user2 = User.new

    user1.full_name = 'Nick Pachulski'
    user2.full_name = 'Chris Pachulski'

    user1.full_name.should == 'Nick Pachulski'
    user2.full_name.should == 'Chris Pachulski'
  end

  describe 'Should filter out logins / signups with invalid credentials' do
    before do
      class User < PMUser
        fields :username, :password
      end
    end

    it 'shouldn\'t allow signups or logins without a username' do
      user = User.new
      user.password = 'password1234'
      user.valid_credentials?.should == false
    end

    it 'shouldn\'t allow signups or logins without a password' do
      user = User.new
      user.username = 'pachun'
      user.valid_credentials?.should == false
    end

    it 'should allow signups and logins with both a username & password' do
      user = User.new
      user.username = 'pachun'
      user.password = 'password1234'
      user.valid_credentials?.should == true
    end
  end

  describe 'Shouldn\'t error when an inherited field (username, email, or password) is explicitly defined by the user in a field' do
    it 'shouldn\'t error when the user defines an email field' do
      class User < PMUser
        fields :email
      end
      user = User.new
      user.email = 'hello@nickpachulski.com'
      user.email.should == 'hello@nickpachulski.com'
    end

    it 'shouldn\'t error when the user defines a username field' do
      class User
        fields :username
      end
      user = User.new
      user.username = 'pachun'
      user.username.should == 'pachun'
    end

    it 'shouldn\'t error when the user defines a password field' do
      class User
        fields :password
      end
      user = User.new
      user.password = 'password1234'
      user.password.should == 'password1234'
    end
  end
end
