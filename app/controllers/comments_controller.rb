class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)

    @comment.user = current_user if user_signed_in?
    @comment.name = "Anónimo" if @comment.name.blank?

    if @comment.save
      redirect_to @post, notice: 'Comentario creado exitosamente.'
    else
      render 'posts/show'
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
  
    # Verifica si el usuario es el creador del comentario o un administrador
    if current_user.id == @comment.user_id || current_user.role == 'admin'
      @comment.destroy
      redirect_to @comment.post, notice: 'Comentario eliminado exitosamente.'
    else
      redirect_to @comment.post, alert: 'No tienes permiso para eliminar este comentario.'
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :name)
    end
end
