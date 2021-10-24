=begin
#ISBM 2.0

#An OpenAPI specification for the ISBM 2.0 RESTful interface.

The version of the OpenAPI document: 2.0
Contact: info@mimosa.org
Generated by: https://openapi-generator.tech
OpenAPI Generator version: 5.2.0

=end

# Note this has been enhanced with the use of the session register 
# for notification support.

require 'cgi'

module IsbmRestAdaptor
  class ProviderRequestServiceApi < ApplicationApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Closes a session.
    # Closes a session of any type. All unexpired messages that have been posted during the session will be expired. ***Note*** This interface is shared by Close Publication Session, Close Subscription Session, Close Provider Request Session, and Close Consumer Request Session.
    # @param session_id [String] The identifier of the session to be accessed (retrieved, deleted, modified, etc.)
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def close_session(session_id, opts = {})
      close_session_with_http_info(session_id, opts)
      nil
    end

    # Closes a session.
    # Closes a session of any type. All unexpired messages that have been posted during the session will be expired. ***Note*** This interface is shared by Close Publication Session, Close Subscription Session, Close Provider Request Session, and Close Consumer Request Session.
    # @param session_id [String] The identifier of the session to be accessed (retrieved, deleted, modified, etc.)
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def close_session_with_http_info(session_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ProviderRequestServiceApi.close_session ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ProviderRequestServiceApi.close_session"
      end
      # resource path
      local_var_path = '/sessions/{session-id}'.sub('{' + 'session-id' + '}', CGI.escape(session_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/xml'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type]

      # auth_names
      auth_names = opts[:debug_auth_names] || ['username_password']

      new_options = opts.merge(
        :operation => :"ProviderRequestServiceApi.close_session",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProviderRequestServiceApi#close_session\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      @api_client.config.session_register.delete(session_id)
      return data, status_code, headers
    end

    # Opens a provider request session for a channel for reading requests and posting responses.
    # @param channel_uri [String] The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
    # @param [Hash] opts the optional parameters
    # @option opts [Session] :session The configuration of the session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided.
    # @return [Session]
    def open_provider_request_session(channel_uri, opts = {})
      data, _status_code, _headers = open_provider_request_session_with_http_info(channel_uri, opts)
      data
    end

    # Opens a provider request session for a channel for reading requests and posting responses.
    # @param channel_uri [String] The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
    # @param [Hash] opts the optional parameters
    # @option opts [Session] :session The configuration of the session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided.
    # @return [Array<(Session, Integer, Hash)>] Session data, response status code and response headers
    def open_provider_request_session_with_http_info(channel_uri, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ProviderRequestServiceApi.open_provider_request_session ...'
      end
      # verify the required parameter 'channel_uri' is set
      if @api_client.config.client_side_validation && channel_uri.nil?
        fail ArgumentError, "Missing the required parameter 'channel_uri' when calling ProviderRequestServiceApi.open_provider_request_session"
      end
      # resource path
      local_var_path = '/channels/{channel-uri}/provider-request-sessions'.sub('{' + 'channel-uri' + '}', CGI.escape(channel_uri.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/xml'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json', 'application/xml'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'session'])

      # return_type
      return_type = opts[:debug_return_type] || 'Session'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['username_password']

      new_options = opts.merge(
        :operation => :"ProviderRequestServiceApi.open_provider_request_session",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProviderRequestServiceApi#open_provider_request_session\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      # update the data with the implicit and provided values
      # (server returns only the ID)
      data.session_type = SessionType::REQUEST_PROVIDER
      data.build_from_hash(opts[:session].to_hash)
      @api_client.config.session_register << data
      return data, status_code, headers
    end

    # Posts a response message on a channel.
    # @param session_id [String] The identifier of the session to which the message will/is posted.
    # @param request_id [String] The identifier of the origianal request for the response.
    # @param [Hash] opts the optional parameters
    # @option opts [Message] :message The Message to be published. Only MessageContent is allowed in the request body.
    # @return [Message]
    def post_response(session_id, request_id, opts = {})
      data, _status_code, _headers = post_response_with_http_info(session_id, request_id, opts)
      data
    end

    # Posts a response message on a channel.
    # @param session_id [String] The identifier of the session to which the message will/is posted.
    # @param request_id [String] The identifier of the origianal request for the response.
    # @param [Hash] opts the optional parameters
    # @option opts [Message] :message The Message to be published. Only MessageContent is allowed in the request body.
    # @return [Array<(Message, Integer, Hash)>] Message data, response status code and response headers
    def post_response_with_http_info(session_id, request_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ProviderRequestServiceApi.post_response ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ProviderRequestServiceApi.post_response"
      end
      # verify the required parameter 'request_id' is set
      if @api_client.config.client_side_validation && request_id.nil?
        fail ArgumentError, "Missing the required parameter 'request_id' when calling ProviderRequestServiceApi.post_response"
      end
      # resource path
      local_var_path = '/sessions/{session-id}/requests/{request-id}/responses'.sub('{' + 'session-id' + '}', CGI.escape(session_id.to_s)).sub('{' + 'request-id' + '}', CGI.escape(request_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/xml'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json', 'application/xml'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body] || @api_client.object_to_http_body(opts[:'message'])

      # return_type
      return_type = opts[:debug_return_type] || 'Message'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['username_password']

      new_options = opts.merge(
        :operation => :"ProviderRequestServiceApi.post_response",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProviderRequestServiceApi#post_response\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      # update the data with the implicit and provided values
      # (server returns only the ID)
      data.message_type = MessageType::RESPONSE
      data.request_message_id = request_id
      data.build_from_hash(opts[:message].to_hash)
      return data, status_code, headers
    end

    # Returns the first non-expired request message or a previously read expired message that satisfies the session message filters.
    # @param session_id [String] The identifier of the session to which the request message was posted.
    # @param [Hash] opts the optional parameters
    # @return [Message]
    def read_request(session_id, opts = {})
      data, _status_code, _headers = read_request_with_http_info(session_id, opts)
      data
    end

    # Returns the first non-expired request message or a previously read expired message that satisfies the session message filters.
    # @param session_id [String] The identifier of the session to which the request message was posted.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Message, Integer, Hash)>] Message data, response status code and response headers
    def read_request_with_http_info(session_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ProviderRequestServiceApi.read_request ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ProviderRequestServiceApi.read_request"
      end
      # resource path
      local_var_path = '/sessions/{session-id}/request'.sub('{' + 'session-id' + '}', CGI.escape(session_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/xml'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type] || 'Message'

      # auth_names
      auth_names = opts[:debug_auth_names] || ['username_password']

      new_options = opts.merge(
        :operation => :"ProviderRequestServiceApi.read_request",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProviderRequestServiceApi#read_request\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      # update the data with the implicit and provided values
      # (server returns only the ID)
      data.message_type = MessageType::REQUEST
      data.build_from_hash(opts[:message].to_hash) unless opts[:messsage].nil?
      return data, status_code, headers
    end

    # Deletes the first request message, if any, in the session message queue.
    # @param session_id [String] The identifier of the session to which the request message was posted.
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def remove_request(session_id, opts = {})
      remove_request_with_http_info(session_id, opts)
      nil
    end

    # Deletes the first request message, if any, in the session message queue.
    # @param session_id [String] The identifier of the session to which the request message was posted.
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def remove_request_with_http_info(session_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ProviderRequestServiceApi.remove_request ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ProviderRequestServiceApi.remove_request"
      end
      # resource path
      local_var_path = '/sessions/{session-id}/request'.sub('{' + 'session-id' + '}', CGI.escape(session_id.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json', 'application/xml'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:debug_body]

      # return_type
      return_type = opts[:debug_return_type]

      # auth_names
      auth_names = opts[:debug_auth_names] || ['username_password']

      new_options = opts.merge(
        :operation => :"ProviderRequestServiceApi.remove_request",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ProviderRequestServiceApi#remove_request\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
