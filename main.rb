# frozen_string_literal: true
require_relative 'configuration'
require_relative 'worker'

require 'oj'

# Read and verify configuration
config = Oj.load(File.read(ENV['CONFIG_FILE_PATH']))
configuration = Configuration.new(source: config.first)

# Spawn worker
worker = Worker.new(configuration)
worker.process
