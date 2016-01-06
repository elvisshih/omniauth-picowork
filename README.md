# OmniAuth Picowork OAuth2 Strategy

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth_picowork', :git => 'git://github.com/elvisshih/omniauth-picowork.git'

And then execute:

    $ bundle

## Usage

Register your application with Picowork to receive an API key: https://www.picowork.com/developer

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer, ENV['PICOWORK_ID'], ENV['PICOWORK_SECRET'], { redirect_uri: ENV['PICOWORK_REDIRECT_URI'] }
end
```
You can now access the OmniAuth Picowork OAuth2 URL: `/auth/developer`.

All OmniAuth strategies expect the callback URL to equal to “/auth/:provider/callback”. :provider takes the name of the strategy (“developer”, “production”, etc.) as listed in the initializer.

config/routes.rb
```ruby
[...]
get '/auth/:provider/callback', to: 'sessions#create'
[...]
```

The create method inside the SessionsController will parse the user data.
request.env['omniauth.auth'] contains the Authentication Hash with all the data about a user.

sessions_controller.rb
```ruby
class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    auth_hash = {
      uid: auth["uid"],
      email: auth["info"]["email"],
      provider: params[:provider],
      image_url: auth["info"]["image_url"],
      nickname: auth["info"]["nickname"],
      access_token: auth.credentials.token
    }
    [...]
  end
end
```
