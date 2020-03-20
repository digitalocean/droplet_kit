require 'spec_helper'

RSpec.describe DropletKit::LoadBalancer do
  let(:lb) { DropletKit::LoadBalancer.new(:sticky_sessions => {:cookie_ttl_seconds => "500"}) }

  describe 'redirect_http_to_https' do
    it 'defaults to false' do
      expect(lb.redirect_http_to_https).to be false
    end

    it 'can be set to true' do
      lb.redirect_http_to_https = true
      expect(lb.redirect_http_to_https).to be true
    end
  end

  describe 'enable_proxy_protocol' do
    it 'defaults to false' do
      expect(lb.enable_proxy_protocol).to be false
    end

    it 'can be set to true' do
      lb.enable_proxy_protocol = true
      expect(lb.enable_proxy_protocol).to be true
    end
  end

  describe 'enable_backend_keepalive' do
    it 'defaults to false' do
      expect(lb.enable_backend_keepalive).to be false
    end

    it 'can be set to true' do
      lb.enable_backend_keepalive = true
      expect(lb.enable_backend_keepalive).to be true
    end
  end

  describe 'sticky_sessions' do
    it 'cookie_ttl_seconds is never a string' do
      expect(lb.sticky_sessions.cookie_ttl_seconds).to eq 500
    end
  end
end
