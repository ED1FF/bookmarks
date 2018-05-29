class ScreenShotJob < ApplicationJob
  queue_as :default

  def perform(bookmark_id, new_url)
    bookmark = Bookmark.find(bookmark_id)
    ws = Webshot::Screenshot.instance
    file_name = Bookmark.file_name(new_url) # normalize png name from url
    ws.capture new_url.to_s, "app/assets/images/#{file_name}.png", width: 200, height: 110, quality: 100
    Cloudinary::Uploader.upload("app/assets/images/#{file_name}.png", use_filename: true, unique_filename: false)
    bookmark.update(sc_shot: file_name + '.png')
  end
end
