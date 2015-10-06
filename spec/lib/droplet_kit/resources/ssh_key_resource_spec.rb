require 'spec_helper'

RSpec.describe DropletKit::SSHKeyResource do
  subject(:resource) { described_class.new(connection: connection) }
  include_context 'resources'

  describe '#all' do
    it 'returns a list of ssh keys' do
      stub_do_api('/v2/account/keys').to_return(body: api_fixture('ssh_keys/all'))
      ssh_keys = resource.all

      expect(ssh_keys).to all(be_kind_of(DropletKit::SSHKey))

      expect(ssh_keys.first.id).to eq(1)
      expect(ssh_keys.first.fingerprint).to eq("f5:d1:78:ed:28:72:5f:e1:ac:94:fd:1f:e0:a3:48:6d")
      expect(ssh_keys.first.public_key).to eq("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDGk5V68BJ4P3Ereh779Vi/Ft2qs/rbXrcjKLGo6zsyeyFUE0svJUpRDEJvFSf8RlezKx1/1ulJu9+kZsxRiUKn example")
      expect(ssh_keys.first.name).to eq("Example Key")
    end

    it_behaves_like 'a paginated index' do
      let(:fixture_path) {'ssh_keys/all'}
      let(:api_path) {'/v2/ssh_keys'}
    end
  end

  describe '#create' do
    it 'creates a ssh key in the users account' do
      ssh_key = DropletKit::SSHKey.new(name: 'Example Key', public_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDbW5JSFLg70Z0/MNNUncNgfxnrHfjBSlWzyF3e+3tNLUVgGagZISnzF4Y03/aS79aiCmbd4vCEcxyB4Wxtpddh example')

      request = stub_do_api('/v2/account/keys', :post).with(
        body: DropletKit::SSHKeyMapping.representation_for(:create, ssh_key)
      ).to_return(body: api_fixture('ssh_keys/create'), status: 201)

      created_key = resource.create(ssh_key)

      expect(request).to have_been_made

      expect(created_key).to be_kind_of(DropletKit::SSHKey)

      expect(created_key.id).to eq(2)
      expect(created_key.fingerprint).to eq("bf:3a:82:fc:4a:25:0b:a3:23:97:fb:4e:e4:88:e1:0e")
      expect(created_key.public_key).to eq("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDbW5JSFLg70Z0/MNNUncNgfxnrHfjBSlWzyF3e+3tNLUVgGagZISnzF4Y03/aS79aiCmbd4vCEcxyB4Wxtpddh example")
      expect(created_key.name).to eq("Example Key")
    end
  end

  describe '#find' do
    it 'returns a single ssh key record' do
      stub_do_api('/v2/account/keys/123').to_return(body: api_fixture('ssh_keys/find'))
      ssh_key = resource.find(id: 123)
      expect(ssh_key.id).to eq(3)
      expect(ssh_key.fingerprint).to eq("32:af:23:06:21:fb:e6:5b:d3:cc:7f:b7:00:0f:79:aa")
      expect(ssh_key.public_key).to eq("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDZEgsAbWmQF+f8TU3F4fCg4yjVzdKudQbbhGb+qRKP5ju4Yo0Zzneia+oFm4bfzG+ydxUlOlbzq+Tpoj+INFv5 example")
      expect(ssh_key.name).to eq("Example Key")
    end

    it_behaves_like 'resource that handles common errors' do
      let(:path) { '/v2/account/keys/123' }
      let(:method) { :get }
      let(:action) { :find }
      let(:arguments) { { id: 123 } }
    end
  end

  describe '#update' do
    it 'updates the SSH key' do
      ssh_key = DropletKit::SSHKey.new(name: 'Example Key')

      request = stub_do_api('/v2/account/keys/123', :put).with(
        body: DropletKit::SSHKeyMapping.representation_for(:update, ssh_key)
      ).to_return(body: api_fixture('ssh_keys/update'), status: 200)

      updated_key = resource.update(ssh_key, id: 123)

      expect(request).to have_been_made

      expect(updated_key.id).to eq(123)
      expect(updated_key.fingerprint).to eq("32:af:23:06:21:fb:e6:5b:d3:cc:7f:b7:00:0f:79:aa")
      expect(updated_key.public_key).to eq("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAQQDZEgsAbWmQF+f8TU3F4fCg4yjVzdKudQbbhGb+qRKP5ju4Yo0Zzneia+oFm4bfzG+ydxUlOlbzq+Tpoj+INFv5 example")
      expect(updated_key.name).to eq("Example Key")
    end
  end

  describe '#delete' do
    it 'deletes an SSH key' do
      request = stub_do_api('/v2/account/keys/123', :delete).to_return(status: 204)
      resource.delete(id: 123)

      expect(request).to have_been_made
    end
  end
end
