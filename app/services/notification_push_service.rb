class NotificationPushService
  @connection_pool = nil

  class << self
    attr_accessor :connection_pool

    def send(token, alert_message = nil, payload = {})
      connection_pool.with do |connection|
        uuid = SecureRandom.uuid
        notification = Apnotic::Notification.new(token)
        notification.alert = alert_message
        notification.custom_payload = { UUID: uuid }.merge(payload)
        notification.topic = "com.YB.Idea-Screener"

        Rails.logger.info "[NotificationPushService] Sending push notification: #{notification.custom_payload}"

        response = connection.push(notification)

        Rails.logger.info "[NotificationPushService] Push result:"\
          " \n headers #{response.headers} \n body #{response.body}"
      end
    end
  end
end