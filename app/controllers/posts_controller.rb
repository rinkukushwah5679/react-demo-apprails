class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :update_post, :delete_post]
  skip_before_action  :verify_authenticity_token 

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    return render json: @posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    render json: {data: {post: @post, user: @post.user}}
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    render json: @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  def create_post
    user = User.where(authentication_token: params[:token]).first
    @post = Post.new(post_params)
    @post.user_id = user.id
    @post.save
    render json: @post
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  def update_post
    @post.update(post_params)
    render json:  @post
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      # format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_post
    @post.destroy
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :description, :user_id)
    end
end
