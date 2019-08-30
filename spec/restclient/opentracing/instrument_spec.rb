# frozen_string_literal: true

require 'spec_helper'
require 'webmock'

RSpec.describe RestClient::OpenTracing::Instrument do
  let(:tracer) { OpenTracingTestTracer.build }

  before do
    OpenTracing.global_tracer = tracer
    RestClient::OpenTracing.instrument
    WebMock.stub_request(:any, 'http://example.com/resource')
           .to_return(status: 200, body: 'ok')
  end

  RSpec.shared_examples 'correct span' do
    it 'records span' do
      expect(spans.count).to eq(1)
    end

    it 'tags path' do
      span = spans.last
      expect(span.tags['path']).to eql(uri.path)
    end

    it 'tags host' do
      span = spans.last
      expect(span.tags['host']).to eql(uri.host)
    end

    it 'tags port' do
      span = spans.last
      expect(span.tags['port']).to eql(uri.port)
    end

    it 'adds operation name' do
      expect(spans.last.operation_name).to match(operation)
    end
  end

  RSpec.shared_examples 'error span' do
    it 'records span' do
      expect(spans.count).to eq(1)
    end

    it 'tags error' do
      span = spans.last
      expect(span.tags['error']).to be_truthy
    end

    it 'tags host' do
      span = spans.last
      expect(span.tags['host']).to eql(uri.host)
    end

    it 'tags port' do
      span = spans.last
      expect(span.tags['port']).to eql(uri.port)
    end

    it 'adds operation name' do
      expect(spans.last.operation_name).to match(operation)
    end
  end

  describe 'tracing simple GET' do
    before do
      RestClient.get 'http://example.com/resource'
    end

    it_behaves_like 'correct span' do
      let(:spans) { tracer.spans }
      let(:uri) { URI.parse('http://example.com/resource') }
      let(:operation) { 'GET' }
    end
  end

  describe 'tracing simple POST' do
    before do
      RestClient.post 'http://example.com/resource', {}
    end

    it_behaves_like 'correct span' do
      let(:spans) { tracer.spans }
      let(:uri) { URI.parse('http://example.com/resource') }
      let(:operation) { 'POST' }
    end
  end

  describe 'tracing errors' do
    before do
      WebMock.stub_request(:get, 'http://example.com/500')
             .to_return(status: 500, body: 'internal service error')
      expect { RestClient.get('http://example.com/500') }.to raise_error
    end

    it_behaves_like 'error span' do
      let(:spans) { tracer.spans }
      let(:uri) { URI.parse('http://example.com/500') }
      let(:operation) { 'GET' }
    end
  end

  describe 'Advanced options with Request' do
    before do
      RestClient::Request.execute(method: :patch,
                                  url: 'http://example.com/resource',
                                  timeout: 10)
    end

    it_behaves_like 'correct span' do
      let(:spans) { tracer.spans }
      let(:uri) { URI.parse('http://example.com/resource') }
      let(:operation) { 'PATCH' }
    end
  end

  describe 'Inject trace information to request' do
    it 'adds trace_id' do
      WebMock.stub_request(:get, 'http://example.com/1')
             .with { |request| !request.headers['Test-Traceid'].nil? }
      RestClient.get('http://example.com/1')
    end
  end

  describe 'Distributed tracing disabled' do
    before do
      RestClient::OpenTracing.instrument do |config|
        config.distributed_tracing = false
      end
    end

    it 'does not add trace id' do
      WebMock.stub_request(:get, 'http://example.com/2')
             .with { |req| req.headers['Test-Traceid'].nil? }
      RestClient.get('http://example.com/2')
    end
  end
end
