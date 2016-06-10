# gem install rest-client
# gem install rspec
# gem install webmock

require 'forwardable'
require 'rest-client'

require_relative 'mailgun_client'

class Emailer
  class << self
    attr_accessor :client

    def client
      @client ||= configure_client
    end

    def unsubscribed?(email)
      response = JSON.parse(RestClient.get client.unsubscribes_endpoint, address: email)
      !response["items"].empty?
    end

    def fetch_emails_for(email)
      response = JSON.parse(RestClient.get client.events_endpoint, recipient: email, pretty: 'yes')
      response["items"].collect { |x| x["message"]["headers"]["message-id"] }
    end

    private

    def configure_client
      MailgunMailClient.configure do |config|
        config.api_key = ''
        config.server_url = ''
        config.api_version = ''
        config.protocol = 'https'
      end
    end
  end

  attr_accessor :from, :to, :subject, :text

  def initialize(from, to, subject, text)
    self.from = from
    self.to = to
    self.subject = subject
    self.text = text
  end

  def send!
    RestClient.post Emailer.client.message_endpoint,
                    from: from,
                    to: to,
                    subject: subject,
                    text: text
  end
end

# Emailer.new('postmaster@sandbox7c7d49794ac34a20adfc812133a5028c.mailgun.org',
#             'adityakapoor.mait@gmail.com',
#             'Hey Budd...',
#             'Hows your life going??? Wanna catch for some :beer:?')
#        .send!
# Emailer.fetch_emails_for('adityakapoor.mait@gmail.com')
# Emailer.unsubscribed?('adityakapoor.mait@gmail.com')
