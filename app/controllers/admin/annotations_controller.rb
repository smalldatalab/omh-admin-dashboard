class Admin::AnnotationsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @annotation = @user.annotations.create(annotation_params)

    # @annotation.save
    redirect_to :back
  end

  def edit
    @user = User.find(params[:user_id])
    @annotation = @user.annotations.find(params[:id])

  end

  def update
    @user = User.find(params[:user_id])
    @annotation = @user.annotations.find(params[:id])
    if @annotation.update(annotation_params)
      redirect_to :back
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @annotation = @user.annotations.find(params[:id])

    @annotation.destroy
    redirect_to :back
  end

  private
    def annotation_params
      params.require(:annotation).permit(:title, :start)
    end
end