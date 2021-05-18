# frozen_string_literal: true

require "tempfile"
require "super_diff/rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.order = :random

  Kernel.srand config.seed
end

module TempFileHelpers
  def with_example_file(content, basename = "fixture")
    file = Tempfile.new(basename)
    file.write(content)
    file.close
    yield file.path
  ensure
    file.unlink
  end

  def with_example_files(files)
    tempfiles = {}

    files.each_pair do |basename, contents|
      tempfile = Tempfile.new(basename)
      tempfiles[basename] = tempfile

      tempfile.write(contents)
      tempfile.close
    end

    yield tempfiles.transform_values(&:path)
  ensure
    tempfiles.each_value(&:unlink)
  end
end
