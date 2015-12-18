# OmniAuth Picowork OAuth2 Strategy

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-picowork', :git => 'git://github.com/elvisshih/omniauth-picowork.git'

And then execute:

    $ bundle

## Usage

Register your application with Picowork to receive an API key: https://www.picowork.com/developer

This is an example that you might put into a Rails initializer at `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :picowork-dev, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
end
```

You can now access the OmniAuth Picowork OAuth2 URL: `/auth/picowork-dev`.

