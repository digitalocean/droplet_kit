require 'spec_helper'

RSpec.describe DropletKit::LoadBalancer do
  let(:lb) { DropletKit::LoadBalancer.new }

  describe 'default' do
    it 'sets rediect_http_to_https to false' do
      expect(lb.redirect_http_to_https).to be false
    end

    it 'sets enable_proxy_protocol to false' do
      expect(lb.enable_proxy_protocol).to be false
    end
  end

  describe 'setting' do
    it 'sets rediect_http_to_https to false' do
      lb.redirect_http_to_https = true
      expect(lb.redirect_http_to_https).to be true
    end

    it 'sets enable_proxy_protocol to false' do
      lb.enable_proxy_protocol = true
      expect(lb.enable_proxy_protocol).to be true
    end
  end
end
