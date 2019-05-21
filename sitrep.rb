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

    FUNCTIONAL_GROUPS = {
      'Critical Services' => 'tier-1',
      'Core Experience' => 'tier-2',
      'Full Experience' => 'tier-3',
      'Uncategorized' => nil,
    }.freeze

    def consul_down_response
      [
        500,
        { 'Content-Type' => 'application/json' },
        [{
          overall: 'outage',
          groups: FUNCTIONAL_GROUPS.keys.each_with_object({}) { |k,h| h[k] = {} },
        }.to_json],
      ]
    end

    def call(env)
      catalog_response = Faraday.get "http://#{CONSUL_HOST}/v1/catalog/serxxvices"
      return consul_down_response unless catalog_response.status == 200

      services = JSON.parse(catalog_response.body)

      # TODO: what if catalog response has > 4,096 entries? thread pool? what
      # is most acceptable way to model this using concurrent-ruby concepts?
      health_futures = services.map do |k,_|
        [
          k,
          Concurrent::Promises.future do
            response = Faraday.get "http://#{CONSUL_HOST}/v1/health/checks/#{k}"
            sleep 1
            response.status == 200 ? JSON.parse(response.body) : {}
          end
        ]
      end.to_h

      response_structure = services.each_with_object({}) do |service_tuple,h|
        service_name = service_tuple[0]
        service_tags = service_tuple[1]
        group = (service_tags & FUNCTIONAL_GROUPS.values).first
        h[group] ||= {}

        service_node_health = health_futures[service_name].value!.map { |node| node['Status'] }
        service_overall = if service_node_health.all? { |x| 'failing' == x }
                            'outage'
                          elsif service_node_health.any? { |x| ['warning', 'failing'].include? x }
                            'degraded'
                          else
                            'healthy'
                          end

        h[group][service_name] = {
          overall: service_overall,
          nodes: service_node_health,
        }
      end

      status_response = {
        overall: 'healthy',
        groups: response_structure,
      }

      [200, {}, [status_response.to_json]]
    end
  end
end
