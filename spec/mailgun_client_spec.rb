require 'spec_helper'

describe Configuration do
  describe 'attributes' do
    it { should respond_to(:api_key) }
    it { should respond_to(:api_version) }
    it { should respond_to(:protocol) }
    it { should respond_to(:server_url) }
  end
end

describe MailgunMailClient do
  describe 'Class Methods' do
    let(:object) do
      MailgunMailClient.configure do |c|
        c.api_key = '124'
        c.server_url = 'sandbox'
        c.api_version = 'v3'
        c.protocol = 'https'
      end
    end

    describe '.configure' do
      it 'should return MailgunMailClient class object' do
        m = MailgunMailClient.configure do |c|
          c.api_key = '124'
        end
        expect(m.api_key).to eq('124')
      end
    end

    describe '.message_endpoint' do
      it { expect(object.message_endpoint).to eq('https://api:124@api.mailgun.net/v3/sandbox/messages') }
    end

    describe '.events_endpoint' do
      it { expect(object.events_endpoint).to eq('https://api:124@api.mailgun.net/v3/sandbox/events') }
    end

    describe '.unsubscribes_endpoint' do
      it { expect(object.unsubscribes_endpoint).to eq('https://api:124@api.mailgun.net/v3/sandbox/unsubscribes') }
    end
  end
end
