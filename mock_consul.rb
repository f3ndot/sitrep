# frozen_string_literal: true

require 'securerandom'
require 'pry-byebug'

module SitRep
  class MockConsul
    FAUX_SERVICES = {
      'fancy-service' => [
        '3.2.0',
        'tier-3',
        'http',
        'microservice'
      ],
      'toast-butter-service' => [
        '1.1.8-p1',
        'tier-3',
        'http',
        'microservice'
      ],
      'dashboard-service' => [
        '0.1.12',
        'tier-2',
        'http',
        'microservice'
      ],
      'authentication-service' => [
        '12.0.0',
        'tier-1',
        'http',
        'microservice'
      ],
      'authorization-service' => [
        '2.6.2',
        'tier-1',
        'http',
        'microservice'
      ],
      'user-service' => [
        '2.0.5',
        'tier-1',
        'http',
        'microservice'
      ],
      'unknown-service' => [
        '2.0.5',
        'http',
        'microservice'
      ],
    }.freeze

    FAUX_HEALTH = [
      {},
      {},
    ]

    RESPONSE_HEADERS = {
      'Content-Type' => 'application/json',
      'X-Consul-Effective-Consistency' => 'leader',
      'X-Consul-Index' => '31854868',
      'X-Consul-Knownleader' => 'true',
      'X-Consul-Lastcontact' => '0',
    }.freeze

    HEALTHCHECK_URL_REGEX = %r{\A/v1/health/checks/(?<service>.+)}

    def node_health(service, total:, warning:, failing:)
      passing = total - warning - failing
      node = {
        ID: nil,
        Node: nil,
        CheckID: 'healthcheck',
        Name: 'Health Status',
        Status: nil,
        Notes: '',
        Output: nil,
        ServiceID: '',
        ServiceName: service,
        ServiceTags: FAUX_SERVICES[service] || [],
      }
      [
        passing.times.each_with_object([]) do |_, a|
          a.push(node.dup.merge(Status: 'passing', Output: 'HTTP GET http://10.10.10.10:48610/api/healthcheck: 200 OK Output: hi'))
        end,
        warning.times.each_with_object([]) do |_, a|
          a.push(node.dup.merge(Status: 'warning', Output: 'HTTP GET http://10.10.10.10:48610/api/healthcheck: 429 Too Many Requests Output: pls slow'))
        end,
        failing.times.each_with_object([]) do |_, a|
          a.push(node.dup.merge(Status: 'failing', Output: 'HTTP GET http://10.10.10.10:48610/api/healthcheck: 500 OK Output: i fell down'))
        end,
      ].flatten.map do |node|
        node.merge(
          ID: SecureRandom.uuid,
          Node: "foobar-#{SecureRandom.alphanumeric(8)}",
        )
      end
    end

    def call(env)
      case env['REQUEST_PATH']
      when '/v1/catalog/services'
        [200, RESPONSE_HEADERS, [FAUX_SERVICES.to_json]]
      when HEALTHCHECK_URL_REGEX
        service_name = HEALTHCHECK_URL_REGEX.match(env['REQUEST_PATH'])[:service]

        return [200, RESPONSE_HEADERS, ['[]']] unless FAUX_SERVICES[service_name]

        [
          200,
          RESPONSE_HEADERS,
          [
            node_health(
              service_name,
              total: 4,
              warning: (rand(10) < 8) ? 0 : 1,
              failing: rand(2),
            ).to_json,
          ]
        ]
      when '/'
        [200, {}, ['Consul Agent']]
      else
        [404, {}, []]
      end
    end
  end
end
