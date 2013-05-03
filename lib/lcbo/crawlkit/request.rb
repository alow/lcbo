module LCBO
  module CrawlKit
    class Request

      MAX_RETRIES = 8

      attr_reader :request_prototype, :query_params, :body_params

      def initialize(request_prototype, query_p = {}, body_p = {})
        @request_prototype = request_prototype
        self.query_params  = query_p
        self.body_params   = body_p
      end

      def query_params=(value)
        @query_params = (value || {})
      end

      def body_params=(value)
        @body_params = request_prototype.body_params.merge(value || {})
      end

      def gettable?
        [:head, :get].include?(request_prototype.http_method)
      end

      def config
        opts = {}
        opts[:method]  = request_prototype.http_method
        opts[:headers] = { 'User-Agent' => LCBO.user_agent }
        opts[:body]    = body_params if (body_params && body_params.any?) && !gettable?
        opts
      end

      def uri
        @uri ||= begin
          template = request_prototype.uri_template.dup
          query_params.reduce(template) do |mem, (key, value)|
            mem.gsub("{#{key}}", value.to_s)
          end
        end
      end

      def run
        _run
      end

      protected

      def _run(tries = 0)
        response = Timeout.timeout(LCBO.config[:timeout]) do
          Typhoeus::Request.new(uri, config).run
        end
        Response.new \
          :code         => response.code,
          :uri          => uri,
          :http_method  => (response.options[:method] || :get),
          :time         => response.time,
          :query_params => query_params,
          :body_params  => body_params,
          :body         => response.body
      rescue Errno::ETIMEDOUT, Timeout::Error
        if tries > LCBO.config[:max_retries]
          raise TimeoutError, "Request failed after timing out #{tries} times"
        end
        _run(tries + 1)
      end

    end
  end
end
