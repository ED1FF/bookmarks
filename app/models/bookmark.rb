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
