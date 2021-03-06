class BookmarksController < ApplicationController
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    @bookmarks = Bookmark.where(user_id: current_user).search(params[:search]).paginate(:page => params[:page], :per_page => 10)
  end

  def friends_bookmarks
    if current_user
      if params[:uid] != nil
        @bookmarks = Bookmark.where(user_id: User.find_by(uid: params[:uid]))
      else
        @info = Bookmark.get_friends_info(current_user)
      end
    else
      redirect_to 'https://localhost:3000/auth/facebook'
    end
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    redirect_to root_path
  end

  # GET /bookmarks/new
  def new
    @bookmark = current_user.bookmarks.build
  end

  # GET /bookmarks/1/edit
  def edit
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = current_user.bookmarks.build(bookmark_params)
    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully created.' }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bookmark_params
      params.require(:bookmark).permit(:sc_shot, :logo, :url, :name)
    end

    def set_auth
      @auth = session[:omniauth] if session[:omniauth]
    end
end
