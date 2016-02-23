require 'json'
require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class TlCs < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "tl_cs"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://cs.ihandy.cn",
        :authorize_url => "/uAuth/oauth2/authorize",
        :token_url => "https://cs.ihandy.cn/uAuth/oauth2/token"
      }

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid { raw_info['user_id'] }

      info do
        {
          :nickname => raw_info['nickname'],
          :email => raw_info['email'],
          :image_url => raw_info["image_url"]
        }
      end

      extra do
        { 
          :raw_info => raw_info, 
          :access_token => access_token.token 
        }
      end

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {:redirect_uri => options.redirect_uri}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
      end

      alias :oauth2_access_token :access_token

      def access_token
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
          :mode => :header,
          :header_format => "%s"
        })
      end

      def raw_info
        @raw_info ||= access_token.get("/uHutt/account/info").parsed["result"]
      end
    end
  end
end

OmniAuth.config.add_camelization 'tlcs', 'TlCs'
