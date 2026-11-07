# frozen_string_literal: true

RSpec.describe TypedEnv do
  it "has a version number" do
    expect(TypedEnv::VERSION).not_to be nil
  end

  it "provides Base class for inheritance" do
    expect(TypedEnv::Base).to be_a(Class)
  end
end
