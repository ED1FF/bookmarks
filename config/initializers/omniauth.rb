Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '678354315668445', '58f19e1f292696c6141ad13c72abfdc7',
  scope: 'user_friends',
    client_options: {
      site: 'https://graph.facebook.com/v3.0',
      authorize_url: "https://www.facebook.com/v3.0/dialog/oauth"
    } ,
    token_params: { parse: :json }
end
