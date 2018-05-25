class User < ApplicationRecord
  has_many :bookmarks
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      a = Koala::Facebook::API.new(auth['credentials']['token']).get_object('me')
      user.profile_link = a['id']
      user.oauth_token = auth['credentials']['token']
      user.oauth_expires_at = Time.at(auth['credentials']['expires_at'])
    end
  end
  def self.auth_token_update(uid , token, time)
    user = User.find_by(uid: uid)
    user.update(oauth_token: token, oauth_expires_at: Time.at(time))

  end
end
