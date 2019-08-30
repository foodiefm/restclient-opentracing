# frozen_string_literal: true

require 'restclient/opentracing/version'
require 'restclient/opentracing/instrument'

module RestClient
  module OpenTracing
    def self.instrument
      @config ||= OpenStruct.new(distributed_tracing: true)
      yield(@config) if block_given?
      require 'rest-client'
      ::RestClient::Request.send(:prepend, Instrument)
      self
    end

    def self.config
      @config
    end
  end
end
