require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SprocketsBug
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true


    def add_missing_assets(basedir, pathspec)
      Dir.glob(pathspec).map{|f| f[basedir.size+1..-1]}.
        select do |file|
          if config.assets.precompile.include?(file)
            false
          elsif File.basename(file)[0...1] == "_"
            false
          else
            true
          end
        end
    end

    images_directory = "#{Rails.root}/app/assets/images"
    config.assets.precompile += add_missing_assets(images_directory, "#{images_directory}/**/*.(gif|png|jpg)")

    stylesheets_directory = "#{Rails.root}/app/assets/stylesheets"
    config.assets.precompile += add_missing_assets(stylesheets_directory, "#{stylesheets_directory}/**/*.s[ac]ss*").map {|f| f.gsub(/(\.sass|\.scss)$/,"")}

    javascripts_directory = "#{Rails.root}/app/assets/javascripts"
    config.assets.precompile += add_missing_assets(javascripts_directory, "#{javascripts_directory}/**/*.erb").map {|f| f.gsub(/(\.erb)$/,"")}
    config.assets.precompile += %w( tinymce/plugins/uploadimage/plugin.js tinymce/plugins/uploadimage/langs/en.js tinymce/plugins/uploaddocument/plugin.js tinymce/plugins/uploaddocument/langs/en.js)

  end
end
