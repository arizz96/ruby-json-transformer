# frozen_string_literal: true

require 'bundler/setup'
require 'oj'

require_relative 'configuration'
require_relative 'worker'

# Load all defined configuration specs
configurations_spec = Oj.load(File.read(ENV.fetch('CONFIG_FILE_PATH', './config.json')))
configurations_spec.each do |configuration_spec|
  # Read and verify configuration
  configuration = Configuration.new(source: configuration_spec)
  # Spawn worker
  worker = Worker.new(configuration)
  worker.process
end
