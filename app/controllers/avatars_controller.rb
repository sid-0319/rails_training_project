class AvatarsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update(avatar_params)
      redirect_to edit_avatar_path, notice: "Avatar updated successfully."
    else
      puts "ERRORS: #{current_user.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    current_user.avatar.purge
    redirect_to edit_avatar_path, notice: "Avatar deleted."
  end

  private

  def avatar_params
  return {} unless params[:user].present?
  params.require(:user).permit(:avatar)
 end
end