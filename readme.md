## Parse Motion
---

#####An active record pattern for you parse models

Right now, **only the user model has been implemented**. I will be working on incorporating PFObjects, PFACLs & PFRoles over the next few days.

## User Usage
---
Subclass PMUser to create your user class.

Define fields using the fields :f1, :f2, etc helper.

To add helper methods, just throw them in the model.

For example, if Players are your user model, you could use:

```ruby
class Player < PMUser
  fields :first_name, :last_name, :username, :password
  
  def full_name
    first_name + ' ' + last_name
  end
end
```
#####Shortcuts
---
The parse iOS API is really long-winded. Here are some helpful shortcuts assuming the following model:

```ruby
class Player < PMUser
  fields :username, :password, :wins, :losses
end
```
<table>
  <tr>
    <td><strong>Parse Motion</td>
    <td><strong>Objective-C</td>
  </tr>
  <tr>
    <td>
      player = Player.new
    </td>
    <td>
      PFUser *player = PFUser.user
    </td>
  </tr>
  <tr>
    <td>
      player.wins = 5
    </td>
    <td>
      [player setObject:5, forKey:'wins']
    </td>
  </tr>
  <tr>
    <td>
      player.wins
    </td>
    <td>
      [player objectForKey:'wins']
    </td>
  </tr>
  <tr>
    <td>
      player.signup
    </td>
    <td>
      [player signUpInBackgroundWithBlock^(BOOL succeeded, NSError *error) { }]
    </td>
  </tr>
  <tr>
    <td>
      Player.login(player)
    </td>
    <td>
      [PFUser logInWithUsernameInBackground:@"username", password:@"password"], block:^(PFUser *user, NSError *error) { }]
    </td>
  </tr>
  <tr>
    <td>
      Player.current
    </td>
    <td>
      [PFUser currentUser]
    </td>
  </tr>
  <tr>
    <td>
      Player.logout
    </td>
    <td>
      [PFUser logOut]
    </td>
  </tr>
  <tr>
</table>

## Handling Logins & Signups
---
I strongly prefer many small chunks of code throughout my programs. For this reason I replaced all blocks with callbacks. You specify the callback object and its selector:

```ruby
class MyViewController
  def viewDidLoad
    super
    
    player = Player.new
    player.delegate = self
    
    player.when :signup_succeeds, 'signed_up'
    player.when :signup_fails, 'signup_failed_with:'
    
    player.when :login_succeeds, 'logged_into:'
    player.when :login_faileds, 'login_failed_with:'
  end
  
  def signed_up
    # stuff
  end
  
  def signup_failed_with(error)
    # stuff
  end
  
  def logged_into(user)
    # stuff
  end
  
  def login_failed_with(error)
    # stuff
  end
end
```





#####Obviously there is a lot to be done before this is gemified.