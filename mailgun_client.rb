class Configuration
  attr_accessor :api_key, :server_url, :api_version, :protocol
end

class MailgunMailClient
  class << self
    extend Forwardable

    def_delegator :@configuration, :api_key, :api_key
    def_delegator :@configuration, :server_url, :server_url
    def_delegator :@configuration, :api_version, :api_version
    def_delegator :@configuration, :protocol, :protocol

    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    self
  end

  def self.message_endpoint
    "#{protocol}://api:#{api_key}@api.mailgun.net/#{api_version}/#{server_url}/messages"
  end

  def self.events_endpoint
    "#{protocol}://api:#{api_key}@api.mailgun.net/#{api_version}/#{server_url}/events"
  end

  def self.unsubscribes_endpoint
    "#{protocol}://api:#{api_key}@api.mailgun.net/#{api_version}/#{server_url}/unsubscribes"
  end
end
