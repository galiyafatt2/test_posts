# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def new; end

  def assign_admin_role
    @user = User.find(params[:user_id])
    @user.update(role: 'admin')
    redirect_to root_path, notice: 'User role updated to admin.'
  end

  private

  def user_params
    params.require(:user).permit(:user_id)
  end
end