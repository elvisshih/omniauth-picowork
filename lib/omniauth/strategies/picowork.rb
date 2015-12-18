require 'json'
require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class PicoworkDev < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "picowork_dev"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://dev.picowork.com",
        :authorize_url => "/uAuth/oauth2/authorize"
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ request.params['user_id'] }

      info do
        {
          :name => raw_info['name'],
          :location => raw_info['city']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= JSON.load(access_token.get('/me.json')).body
      end

      def authorize_params
        super.tap do |params|
          params[:response_type] ||= 'code'
          params[:redirect_uri] ||= "https://pbc-staging.picowork.com/auth/picowork/callback"
        end
      end
    end

    class PicoworkLocal < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "picowork_local"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://dev.picowork.com",
        :authorize_url => "/uAuth/oauth2/authorize",
        :token_url => "https://dev.picowork.com/uAuth/oauth2/token"
      }

      option :scope, 'r_basicprofile r_emailaddress'
      option :fields, ['user_id']

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      # uid{ request.params['user_id'] }
      uid { raw_info['user_id'] }

      info do
        {
          :name => raw_info['name'],
          :location => raw_info['city']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def callback_phase
        with_authorization_code! do
          super
        end
      rescue NoAuthorizationCodeError => e
        fail!(:no_authorization_code, e)
      rescue OmniAuth::Facebook::SignedRequest::UnknownSignatureAlgorithmError => e
        fail!(:unknown_signature_algorithm, e)
      end
      
      alias :oauth2_access_token :access_token

      def access_token
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
          :mode => :query,
          :param_name => 'oauth2_access_token',
          :expires_in => oauth2_access_token.expires_in,
          :expires_at => oauth2_access_token.expires_at
        })
      end

      def raw_info
        @raw_info ||=  access_token.get("/uHutt/contact/:(#{option_fields.join(',')})?format=json").parsed
      end

      def authorize_params
        super.tap do |params|
          params[:response_type] ||= 'code'
          params[:redirect_uri] ||= options.redirect_uri
        end
      end

      private

      def option_fields
        fields = options.fields
        fields.map! { |f| f == "picture-url" ? "picture-url;secure=true" : f } if !!options[:secure_image_url]
        fields
      end

      def user_name
        name = "#{raw_info['firstName']} #{raw_info['lastName']}".strip
        name.empty? ? nil : name
      end
    end
  end
end

# OmniAuth.config.add_camelization 'picowork_local', 'PicoworkLocal'