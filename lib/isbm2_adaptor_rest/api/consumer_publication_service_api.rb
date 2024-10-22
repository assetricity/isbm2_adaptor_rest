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
  class ConsumerPublicationServiceApi < ApplicationApi
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
        @api_client.config.logger.debug 'Calling API: ConsumerPublicationServiceApi.close_session ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ConsumerPublicationServiceApi.close_session"
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
        :operation => :"ConsumerPublicationServiceApi.close_session",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ConsumerPublicationServiceApi#close_session\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      @api_client.config.session_register.delete(session_id)
      return data, status_code, headers
    end

    # Opens a subscription session for a channel.
    # @param channel_uri [String] The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
    # @param [Hash] opts the optional parameters
    # @option opts [Session] :session The configuration of the subscription session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided.
    # @return [Session]
    def open_subscription_session(channel_uri, opts = {})
      data, _status_code, _headers = open_subscription_session_with_http_info(channel_uri, opts)
      data
    end

    # Opens a subscription session for a channel.
    # @param channel_uri [String] The identifier of the channel to be accessed (retrieved, deleted, modified, etc.)
    # @param [Hash] opts the optional parameters
    # @option opts [Session] :session The configuration of the subscription session, i.e., topic filtering, content-filtering, and notication listener address. Only the Topics, ListenerURL, and FilterExpressions are to be provided.
    # @return [Array<(Session, Integer, Hash)>] Session data, response status code and response headers
    def open_subscription_session_with_http_info(channel_uri, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ConsumerPublicationServiceApi.open_subscription_session ...'
      end
      # verify the required parameter 'channel_uri' is set
      if @api_client.config.client_side_validation && channel_uri.nil?
        fail ArgumentError, "Missing the required parameter 'channel_uri' when calling ConsumerPublicationServiceApi.open_subscription_session"
      end
      # resource path
      local_var_path = '/channels/{channel-uri}/subscription-sessions'.sub('{' + 'channel-uri' + '}', CGI.escape(channel_uri.to_s))

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
        :operation => :"ConsumerPublicationServiceApi.open_subscription_session",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ConsumerPublicationServiceApi#open_subscription_session\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      # update the data with the implicit and provided values 
      # (server returns only the ID)
      data.session_type = SessionType::PUBLICATION_CONSUMER
      data.build_from_hash(opts[:session].to_hash)
      @api_client.config.session_register << data
      return data, status_code, headers
    end

    # Returns the first non-expired publication message or a previously read expired message that satisfies the session message filters.
    # @param session_id [String] The identifier of the session to which the publication was posted.
    # @param [Hash] opts the optional parameters
    # @return [Message]
    def read_publication(session_id, opts = {})
      data, _status_code, _headers = read_publication_with_http_info(session_id, opts)
      data
    end

    # Returns the first non-expired publication message or a previously read expired message that satisfies the session message filters.
    # @param session_id [String] The identifier of the session to which the publication was posted.
    # @param [Hash] opts the optional parameters
    # @return [Array<(Message, Integer, Hash)>] Message data, response status code and response headers
    def read_publication_with_http_info(session_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ConsumerPublicationServiceApi.read_publication ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ConsumerPublicationServiceApi.read_publication"
      end
      # resource path
      local_var_path = '/sessions/{session-id}/publication'.sub('{' + 'session-id' + '}', CGI.escape(session_id.to_s))

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
        :operation => :"ConsumerPublicationServiceApi.read_publication",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ConsumerPublicationServiceApi#read_publication\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      # update the data with the implicit and provided values
      # (server returns only the ID)
      data.message_type = MessageType::PUBLICATION
      return data, status_code, headers
    end

    # Removes the first, if any, publication message in the subscription queue.
    # @param session_id [String] The identifier of the session to which the publication was posted.
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def remove_publication(session_id, opts = {})
      remove_publication_with_http_info(session_id, opts)
      nil
    end

    # Removes the first, if any, publication message in the subscription queue.
    # @param session_id [String] The identifier of the session to which the publication was posted.
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def remove_publication_with_http_info(session_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ConsumerPublicationServiceApi.remove_publication ...'
      end
      # verify the required parameter 'session_id' is set
      if @api_client.config.client_side_validation && session_id.nil?
        fail ArgumentError, "Missing the required parameter 'session_id' when calling ConsumerPublicationServiceApi.remove_publication"
      end
      # resource path
      local_var_path = '/sessions/{session-id}/publication'.sub('{' + 'session-id' + '}', CGI.escape(session_id.to_s))

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
        :operation => :"ConsumerPublicationServiceApi.remove_publication",
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ConsumerPublicationServiceApi#remove_publication\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
