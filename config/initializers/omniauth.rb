Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, 'ed14a8fa57c188397fd6', '0fcab14b2a06cf0396505880ce5028540e489c23'
end
