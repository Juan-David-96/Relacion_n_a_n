class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    
    if @post.save
      redirect_to @post, notice: 'Publicación creada exitosamente.'
    else
      render :new
    end
  end
  
  
  

  

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post = Post.find(params[:id])
  
    # Verifica si el usuario es el creador del post o un administrador
    if current_user.id == @post.user_id || current_user.role == 'admin'
      @post.destroy
      redirect_to posts_path, notice: 'Publicación eliminada exitosamente.'
    else
      redirect_to @post, alert: 'No tienes permiso para eliminar esta publicación.'
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def authorize_user!
      unless current_user == @post.user || current_user.admin?  # Requiere que el usuario sea el dueño o un admin
        redirect_to @post, alert: 'No tienes permiso para eliminar esta publicación.'
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
