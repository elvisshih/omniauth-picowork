require 'json'
require 'omniauth-oauth2'
module OmniAuth
  module Strategies
    class Developer < OmniAuth::Strategies::OAuth2
      # Give your strategy a name.
      option :name, "developer"

      # This is where you pass the options you would pass when
      # initializing your consumer from the OAuth gem.
      option :client_options, {
        :site => "https://developer.picowork.com",
        :authorize_url => "https://developer.picowork.com/uAuth/oauth2/authorize",
        :token_url => "https://developer.picowork.com/uAuth/oauth2/token"
      }

      #option :scope, 'r_basicprofile r_emailaddress'
      # option :fields, ['user_id', 'email']

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
        { 'raw_info' => raw_info }
      end

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {:redirect_uri => options.redirect_uri}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
      end

      def raw_info
        path = options.client_options.site + '/uHutt/account/info'
        uri = URI(path)
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          req = Net::HTTP::Get.new(uri.path)
          req.add_field 'authorization', access_token.token
          http.request req
        end
        @raw_info ||= MultiJson.decode(res.body)['result']
      end

    #   private

    #   def option_fields
    #     fields = options.fields
    #     fields.map! { |f| f == "picture-url" ? "picture-url;secure=true" : f } if !!options[:secure_image_url]
    #     fields
    #   end

    #   def user_name
    #     name = "#{raw_info['firstName']} #{raw_info['lastName']}".strip
    #     name.empty? ? nil : name
    #   end
    end
  end
end

# OmniAuth.config.add_camelization 'picowork_local', 'PicoworkLocal'
