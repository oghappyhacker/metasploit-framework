# -*- coding:binary -*-
require 'spec_helper'

require 'stringio'
require 'rex/java/serialization'
require 'rex/proto/rmi'
require 'msf/java/rmi/client'

describe Msf::Java::Rmi::Client::Jmx::Server::Builder do
  subject(:mod) do
    mod = ::Msf::Exploit.new
    mod.extend ::Msf::Java::Rmi::Client
    mod.send(:initialize)
    mod
  end

  let(:default_new_client) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\xf0\xe0\x74\xea\xad\x0c\xae\xa8\x70"
  end

  let(:auth_stream) do
    "\x72\x00\x13\x5b\x4c\x6a\x61\x76\x61\x2e\x6c\x61\x6e\x67\x2e\x53" +
    "\x74\x72\x69\x6e\x67\x3b\xad\xd2\x56\xe7\xe9\x1d\x7b\x47\x02\x00" +
    "\x00\x70\x78\x70\x00\x00\x00\x02\x74\x00\x04\x72\x6f\x6c\x65\x74" +
    "\x00\x08\x70\x61\x73\x73\x77\x6f\x72\x64"
  end

  let(:credentials_new_client) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\xf0\xe0\x74\xea\xad\x0c\xae\xa8\x75\x72\x00\x13\x5b\x4c\x6a" +
    "\x61\x76\x61\x2e\x6c\x61\x6e\x67\x2e\x53\x74\x72\x69\x6e\x67\x3b" +
    "\xad\xd2\x56\xe7\xe9\x1d\x7b\x47\x02\x00\x00\x70\x78\x70\x00\x00" +
    "\x00\x02\x74\x00\x04\x72\x6f\x6c\x65\x74\x00\x08\x70\x61\x73\x73" +
    "\x77\x6f\x72\x64"
  end

  let(:new_client_opts) do
    {
      username: 'role',
      password: 'password'
    }
  end

  describe "#build_jmx_new_client" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_new_client).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a lookup Call for an empty name" do
        expect(mod.build_jmx_new_client.encode).to eq(default_new_client)
      end
    end

    context "when opts with credentials" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_new_client(new_client_opts)).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a newClient Call with credentials" do
        expect(mod.build_jmx_new_client(new_client_opts).encode).to eq(credentials_new_client)
      end
    end
  end

  describe "#build_jmx_new_client_args" do
    it "return an Array" do
      expect(mod.build_jmx_new_client_args('role', 'password')).to be_an(Array)
    end

    it "returns an Array with a Rex::Java::Serialization::Model::NewArray" do
      expect(mod.build_jmx_new_client_args('role', 'password')[0]).to be_a(Rex::Java::Serialization::Model::NewArray)
    end

    it "builds a correct stream" do
      expect(mod.build_jmx_new_client_args('role', 'password')[0].encode).to eq(auth_stream)
    end
  end
end

