# frozen_string_literal: true

require "spec_helper"

# Counts the runs of its rule, by attribute
class CountingValidator < ActiveModel::EachValidator
  def self.runs
    @runs ||= Hash.new(0)
  end

  def validate_each(_record, attribute, _value)
    self.class.runs[attribute] += 1
  end
end

RSpec.describe TypedEnv::Base, "how often rules run" do
  before do
    ENV.clear
    CountingValidator.runs.clear
  end

  let(:settings) do
    Class.new(TypedEnv::Base) do
      var :one, default: "1", validates: { counting: true }
      var :two, default: "2", validates: { counting: true }
      var :three, default: "3", validates: { counting: true }
    end
  end

  # It used to validate everything at once, and then every var again through validate_var!, each time running all
  # the rules: (N + 1) × N runs instead of N.
  it "runs every var's rule once for validate!" do
    settings.validate!

    expect(CountingValidator.runs).to eq(one: 1, two: 1, three: 1)
  end

  it "reports every failing var in one error" do
    failing = Class.new(TypedEnv::Base) do
      var :host, validates: { presence: true }
      var :port, type: :integer, default: -1, validates: { numericality: { greater_than: 0 } }
    end

    expect { failing.validate! }.to raise_error(TypedEnv::ValidationError, "Host can't be blank, Port must be greater than 0")
  end

  it "reports only the written var's own errors when one is written" do
    written = Class.new(TypedEnv::Base) do
      default_writer { |_value, _setting| nil }
      var :host, validates: { presence: true } # unset, so invalid as it stands
      var :port, type: :integer, default: 1, validates: { numericality: { greater_than: 0 } }
    end

    expect { written.port = 8080 }.not_to raise_error
    expect { written.port = 0 }.to raise_error(TypedEnv::ValidationError, "Port must be greater than 0")
  end

  # A rule may read another var — one declared later, and with no rule of its own, included
  it "gives a rule every var to read, whenever it was declared" do
    conditional = Class.new(TypedEnv::Base) do
      var :token, validates: { presence: { if: -> { auth_enabled } } }
      var :auth_enabled, type: :boolean, default: true
    end

    expect { conditional.validate! }.to raise_error(TypedEnv::ValidationError, "Token can't be blank")
    ENV["AUTH_ENABLED"] = "false"
    expect { conditional.validate! }.not_to raise_error
  end
end
