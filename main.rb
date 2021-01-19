# frozen_string_literal: true

require 'bundler/setup'
require 'oj'

require_relative 'configuration'
require_relative 'worker'

# Read and verify configuration
config = Oj.load(File.read(ENV.fetch('CONFIG_FILE_PATH', './config.json')))
configuration = Configuration.new(source: config.first)

# Spawn worker
worker = Worker.new(configuration)
worker.process
