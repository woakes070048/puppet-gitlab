paths_to_be_protected = [
  "#{Rails.application.config.relative_url_root}/users/password",
  "#{Rails.application.config.relative_url_root}/users/sign_in",
  "#{Rails.application.config.relative_url_root}/api/#{API::API.version}/session.json",
  "#{Rails.application.config.relative_url_root}/api/#{API::API.version}/session",
  "#{Rails.application.config.relative_url_root}/users",
  "#{Rails.application.config.relative_url_root}/users/confirmation",
  "#{Rails.application.config.relative_url_root}/unsubscribes/"

]

# Create one big regular expression that matches strings starting with any of
# the paths_to_be_protected.
paths_regex = Regexp.union(paths_to_be_protected.map { |path| /\A#{Regexp.escape(path)}/ })

unless Rails.env.test?
  Rack::Attack.throttle('protected paths', limit: 10, period: 60.seconds) do |req|
    if req.post? && req.path =~ paths_regex
      req.ip
    end
  end
end
