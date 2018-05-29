class Bookmark < ApplicationRecord
  belongs_to :user
  validates_url :url, url: true
  after_create do
    new_url = url
    begin
      page = MetaInspector.new(new_url.to_s)
      update(url: new_url, name: page.title, logo: page.images.favicon)
      ScreenShotJob.delay_until(Time.now + 1).perform_later(self.id, new_url)
    rescue StandardError
       delete
    end
  end

  def self.search(search)
    if search
      where(['url LIKE ?', "%#{search}%"])
    else
      all
    end
  end


  # def self.get_friends_bookmarks(current_user)
  #   @graph = Koala::Facebook::API.new(current_user.oauth_token)
  #   friends = @graph.get_connections("me", 'friends')
  #   friends = friends.to_a
  #   bookmarks = []
  #   friends.each do |friend|
  #     temp_arr = []
  #     a = User.find_by(uid: friend['id'])
  #     b = Bookmark.where(user_id: a.id).all
  #     b.each do |bookmark|
  #       temp_arr << bookmark
  #     end
  #     bookmarks << temp_arr
  #   end
  #   bookmarks
  # end

  def self.get_friends_info(current_user)
    @graph = Koala::Facebook::API.new(current_user.oauth_token)
    friends = @graph.get_connections('me', 'friends')
    friends = friends.to_a
    friends_info = []
    friends.each do |friend|
      temp_arr = []
      temp_arr << friend['id']
      temp_arr << friend['name']
      friends_info << temp_arr
    end
    friends_info
  end


  def self.file_name(url)
    url = url.delete('.')
    url = url.delete(':')
    url = url.delete('/')
    url = url.delete('?')
    url = url.delete('=')
    url = url.delete('+')
    url = url.delete('&')
    url = url.delete(';')
    url
  end

  def url_normalize(bookmark)
    url = bookmark.url
    url = 'https://' + url
    url
  end
end
