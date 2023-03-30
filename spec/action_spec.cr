require "./spec_helper"

require "yaml"

describe Action do
  name = "sayhi"
  config = {
    "command" => YAML.parse("echo hello world"),
    "alias" => YAML.parse("hi")
  }
  args = [] of String
  subject = Action.new(name, config, args)

  it "has the correct name" do
    subject.name.should eq "sayhi"
  end

  it "has the correct alias" do
    subject.alias.should eq "hi"
  end

  it "has the correct aliases" do
    subject.aliases.should eq ["hi"]
  end
end
