require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mosaicone007
  class Application < Rails::Application
    config.i18n.default_locale = 'es-MX'

    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :sidekiq
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false
  end
end
