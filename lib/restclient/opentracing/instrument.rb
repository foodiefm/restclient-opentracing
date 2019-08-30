# frozen_string_literal: true

module RestClient
  module OpenTracing
    module Instrument
      def execute(&block)
        uri = URI.parse(url)
        scope = ::OpenTracing.start_active_span([method.to_s.upcase, uri.host].join(' '),
                                                tags: tags(uri))
        span = scope.span

        if RestClient::OpenTracing.config.distributed_tracing
          ::OpenTracing.inject(span.context, ::OpenTracing::FORMAT_RACK,
                               processed_headers)
        end

        response = super(&block)

        if response.is_a?(::RestClient::Response)
          span.set_tag('status', response.code)
        end

        response
      rescue ::RestClient::ExceptionWithResponse => e
        span.set_tag('error', true)
        span.log_kv(key: 'error', value: e.to_s)
        span.set_tag('status', e.http_code)

        raise e
      rescue Exception => e
        span.set_tag('error', true)
        span.log_kv(key: 'error', value: e.to_s)
        raise e
      ensure
        scope.close
      end

      private

      def tags(uri)
        {
          'path' => uri.path,
          'host' => uri.host,
          'port' => uri.port
        }
      end
    end
  end
end
