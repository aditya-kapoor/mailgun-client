require 'spec_helper'
require 'byebug'

describe Emailer do
  describe 'Instance Methods' do

    describe 'attributes' do
      let(:subject) { Emailer.new('', '', '', '') }

      it { should respond_to(:from) }
      it { should respond_to(:to) }
      it { should respond_to(:subject) }
      it { should respond_to(:text) }
    end

    describe '#send!' do
      let(:subject) { Emailer.new('', '', '', '') }

      before do
        stub_request(:post, 'https://api.mailgun.net///messages')
        .with(body: { from: "", subject: "", text: "", to: ""})
        .to_return(status: 200, body: 'OK.', headers: {})
      end

      it { expect(subject.send!).to eq('OK.') }
    end
  end

  describe 'Class Methods' do
    describe '.unsubscribed?' do
      context 'when not unsubscribed' do
        before do
          stub_request(:get, 'https://api.mailgun.net///unsubscribes')
          .to_return(status: 200, body: "{\"items\":[]}", headers: {})
        end
        it { expect(Emailer.unsubscribed?('email@example.com')).to be false }
      end

      context 'when unsubscribed' do
        before do
          stub_request(:get, 'https://api.mailgun.net///unsubscribes')
          .to_return(status: 200, body: "{\"items\":[\"email@example.com\"]}", headers: {})
        end
        it { expect(Emailer.unsubscribed?('email@example.com')).to be true }
      end
    end

    describe '.fetch_emails_for' do
      before do
        stub_request(:get, 'https://api.mailgun.net///events')
        .to_return(status: 200, body: "{\"items\":[{\"message\":{\"headers\":{\"message-id\":1}}},{\"message\":{\"headers\":{\"message-id\":2}}},{\"message\":{\"headers\":{\"message-id\":3}}}]}", headers: {})
      end
      it { expect(Emailer.fetch_emails_for('email@example.com')).to eq [1, 2, 3] }
    end
  end
end
