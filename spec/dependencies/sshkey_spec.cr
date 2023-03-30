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
  end
end
