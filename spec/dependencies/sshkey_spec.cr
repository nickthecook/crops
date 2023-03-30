require "spec"
require "../spec_helper"

require "dependencies/sshkey"

Spectator.describe Dependencies::Sshkey do
  subject { Dependencies::Sshkey.new("config/dev/id_rsa") }

  describe "#met?" do
    it "returns false" do
      expect(subject.met?).to be_false
    end
  end

  describe "#meet" do

    mock Secrets

    it "loads secrets" do
      secrets = mock(Secrets)
      allow(secrets).to receive(:load).and_return(nil)
      subject.meet
      expect(secrets).to have_received(:load)
    end
  end
end
