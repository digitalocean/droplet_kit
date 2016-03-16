require 'spec_helper'

RequestCounter = Struct.new(:count)

RSpec.describe DropletKit::PaginatedResource do
  let(:resource) { ResourceKit::Resource.new(connection: connection) }
  let(:request_count) { RequestCounter.new(0) }

  let(:connection) { Faraday.new {|b| b.adapter :test, stubs } }
  let(:response_size) { 40 }
  let(:stubs) { stub_pager_request(response_size) }
  let(:action) { ResourceKit::Action.new(:find, :get, '/droplets') }

  before do
    action.query_keys :per_page, :page
    action.handler(200) { |r| JSON.load(r.body)['objects'] }
  end

  describe '#initialize' do
    it 'initializes with a action and resource' do
      instance = DropletKit::PaginatedResource.new(action, resource)
      expect(instance.action).to be(action)
      expect(instance.resource).to be(resource)
    end
  end

  describe "#total_pages" do
    let(:instance) { DropletKit::PaginatedResource.new(action, resource) }
    it "returns nil if no request made" do
      expect(instance.total_pages).to be_nil
    end

    it "returns correct page count after request made" do
      instance.take(20)
      expect(instance.total_pages).to eq(2)
    end

    context "when results are empty" do
      let(:stubs) { stub_pager_request(0) }
      it "returns 0" do
        instance.take(1)
        expect(instance.total_pages).to eq(0)
      end
    end
  end

  describe '#[]' do
    subject(:paginated) { DropletKit::PaginatedResource.new(action, resource) }

    it 'returns the nth element in the collection' do
      paginated.each_with_index do |elem, i|
        expect(paginated[i]).to eq(elem)
      end
    end
  end

  describe '#each' do
    subject(:paginated) { DropletKit::PaginatedResource.new(action, resource) }

    it 'iterates over every object returned from the API' do
      total = 0
      paginated.each do |object|
        total += 1
      end

      expect(total).to eq(40)
    end

    it 'called the API twice' do
      expect {|b| paginated.each {|c| c } }.to change { request_count.count }.to(2).from(0)
    end

    it 'returns the correct objects' do
      expect(paginated.first(3)).to eq([0,1,2])
    end

    context 'for changing size' do
      subject(:paginated) { DropletKit::PaginatedResource.new(action, resource, per_page: 40) }

      it 'only calls the API once' do
        expect {|b| paginated.each {|c| c } }.to change { request_count.count }.to(1).from(0)
      end
    end
  end
end
