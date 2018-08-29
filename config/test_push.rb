require 'houston'

APN = Houston::Client.production
APN.certificate = File.read('server_certificates_bundle_sandbox_new.pem')
APN.passphrase = ENV['APPLE_PUSH_NOTIFICATION_PASS']

# An example of the token sent back when a device registers for notifications
token = '6c917f7bb279b58378db95109e64dfef43f86e1c814bd5a486931f4ed2229e3c' #mytoken


# Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
notification = Houston::Notification.new(device: token)

notification.alert    = {
  title:  "HELLO WORLD",
  body:   "HELLO WORLD BODY",
  tag:  "push-simple-demo-notification-tag",
  action: "View"
}

notification.category = "INVITE_CATEGORY"
notification.content_available = true

# Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
notification.badge = 1
notification.sound = 'sosumi.aiff'
notification.content_available = true
notification.mutable_content = true
notification.custom_data = { id: 'suvey_id', type: 'survey_type' }

p "Error: #{notification.error}."

# And... sent! That's all it takes.
APN.push(notification)
puts "Error: #{notification.error}." if notification.error
puts "notifications params:#{notification} #{notification.custom_data}"