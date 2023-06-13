Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # Adjust this if you want to specify the domains that are allowed to make requests.

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete]
  end
end
