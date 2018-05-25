class Bookmark < ApplicationRecord
  belongs_to :user
  ws = Webshot::Screenshot.instance

  after_create do
    if url.to_s.include? 'http'
      new_url = url
    else
      new_url = url_normalize(self)
    end
    begin
      file_name = file_name(new_url) #normalize png name from url
      page = MetaInspector.new(new_url.to_s)
      ws.capture new_url.to_s, "app/assets/images/#{file_name}.png", width: 200, height: 110, quality: 100
      update(url: new_url ,sc_shot: file_name + '.png',name: page.title , logo: page.images.favicon)
    rescue
      destroy
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
    friends = @graph.get_connections("me", 'friends')
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

  private

  def file_name(url)
    url = url.delete('.')
    url = url.delete(':')
    url = url.delete('/')
    url
  end

  def url_normalize(bookmark)
    url = bookmark.url
    url = 'https://' + url
    url
  end
end
