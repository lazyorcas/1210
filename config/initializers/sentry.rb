# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = "https://132a11ed87a7abf94187a89ccc033255@o4505980061155328.ingest.sentry.io/4505980061220864"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 0.1
  # or
  # config.traces_sampler = lambda do |_context|
  #   true
  # end

  config.enabled_environments = ["production"]
end
