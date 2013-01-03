class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    Parse.setApplicationId('5IOtGbU8fc9FmPX3jmrieNviZxnNgiNN0qercWEs', clientKey:'GgXHoPidP2ZXLeuIhxHgtRB04lxH3Vgr8lJaVDN1')
    # application.registerForRemoteNotificationTypes(UIRemoteNotificationTypeBadge)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = TestVC.new
    @window.makeKeyAndVisible

    true
  end

  # push setup
  def application(application, didRegisterForRemoteNotificationsWithDeviceToken:token)
    PFPush.storeDeviceToken(token)
    PFPush.subscribeToChannelInBackground('test')
  end

  def application(application, didFailToRegisterForRemoteNotificationsWithError:error)
    App.alert("failed to register for push because: #{error}")
  end

  # push handling
  def application(application, didReceiveRemoteNotification:user_info)
    App.alert("push received at #{Time.now}: #{user_info}")
  end
end
