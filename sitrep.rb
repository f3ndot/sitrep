# frozen_string_literal: true

require 'concurrent'
require 'faraday'
require 'pry-byebug' if ENV['RACK_ENV'] == 'development'

module SitRep
  class Status
    CONSUL_HOST = if ENV['RACK_ENV'] == 'development'
                    ENV['CONSUL_HOST'] || '127.0.0.1:8500'
                  else
                    ENV['CONSUL_HOST'] or raise 'Set CONSUL_HOST'
                  end.freeze

    def call(env)
      response = Faraday.get "http://#{CONSUL_HOST}/v1/catalog/sexrvices"

      return [500, { 'Content-Type' => 'application/json' }, ['TODO']] unless response.status == 200


      [200, {}, ['TODO']]
    end
  end
end
