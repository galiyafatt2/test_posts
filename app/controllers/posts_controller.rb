# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :submit_for_review, :approve, :reject]
  before_action :authorize_user, except: [:index, :new, :create, :generate_report]

  def index
    @user_posts = current_user.posts
    if current_user.admin?
      @posts = Post.where(status: :pending) # Администраторы видят только посты на проверке
    else
      @posts = Post.where(status: :approved)
    end
    filter_posts
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if current_user.admin?
      @post.status = :approved # Изменение состояния на :approved
    end

    if @post.save
      params[:post][:attachments]&.each do |a|
        @attachment = @post.attachments.create!(file: a)
      end

      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  def generate_report
    @posts = Post.all.where(status: 'approved')
    respond_to do |format|
      format.xlsx {
        render xlsx: 'generate_report'
      }
    end
  end

  def submit_for_review
    if @post.draft?
      PostStateChangeJob.perform_later(@post.id, 'submit_for_review')
      redirect_to @post, notice: 'Post has been sent for approval'
    end
  end

  def approve
    if @post.pending?
      PostStateChangeJob.perform_later(@post.id, 'approve')
      redirect_to @post, notice: 'Post has been approved'
    end
  end

  def reject
    if @post.pending?
      PostStateChangeJob.perform_later(@post.id, 'reject')
      redirect_to @post, notice: 'Post has been rejected'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :status, :region)
  end

  def authorize_user
    unless current_user.admin? || @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to perform this action."
    end
  end

  def filter_posts
    @posts = @posts.where(region: params[:region]) if params[:region].present?
  end
end
