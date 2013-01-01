# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|

  # app info
  app.name = 'ParseInMotion'
  app.sdk_version = '6.0'
  app.device_family = [:iphone, :ipad]

  # app id / prov prof link
  app.identifier = 'com.pachun.parseinmotion'
  app.seed_id = 'TWQR5PJHCM'
  app.codesign_certificate = 'iPhone Developer: Nicholas Pachulski (3AN7NHZ6WD)'
  app.provisioning_profile = './certificates/pim.mobileprovision'

  # push-enabling configurations
  app.entitlements['application-identifier'] = app.seed_id + '.' + app.identifier
  app.entitlements['keychain-access-groups'] = [ app.seed_id + '.' + app.identifier ]
  app.entitlements['aps-environment'] = 'development'
  app.entitlements['get-task-allow'] = true

  # parse SDK
  app.libs << ['/usr/lib/libz.1.1.3.dylib', '/usr/lib/libsqlite3.dylib']
  app.frameworks += [ 'AudioToolbox', 'Accounts', 'AdSupport', 'CFNetwork', 'CoreGraphics', 'CoreLocation',
                      'MobileCoreServices', 'QuartzCore', 'Security', 'Social', 'StoreKit', 'SystemConfiguration']
  app.vendor_project('vendor/Parse.framework', :static, :products => ['Parse'], :headers_dir => 'Headers')
end
