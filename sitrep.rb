# frozen_string_literal: true

require 'concurrent'
require 'pry-byebug' if ENV['RACK_ENV'] == 'development'

module SitRep
  class Status
    def call(env)
      [200, {}, ['TODO']]
    end
  end
end
