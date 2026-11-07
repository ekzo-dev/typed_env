# frozen_string_literal: true

require_relative "lib/typed_env/version"

Gem::Specification.new do |spec|
  spec.name = "typed_env"
  spec.version = TypedEnv::VERSION
  spec.authors = ["Dmitry Arkhipov"]
  spec.email = ["d.arkhipov@ekzo.dev"]

  spec.summary = "Type-safe environment variables management for Ruby applications"
  spec.description = "TypedEnv provides a clean DSL for managing environment variables with type coercion, validations, and default values"
  spec.homepage = "https://github.com/ekzo-dev/typed_env"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/ekzo-dev/typed_env/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/ekzo-dev/typed_env/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ . appveyor Gemfile Rakefile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # No runtime dependencies. ActiveModel (>= 7.1), when the application has it, takes over the validations.
end
