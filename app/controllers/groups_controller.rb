class GroupsController < ApplicationController

  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destory]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def edit
  end

  def destroy
    @group.destroy
    #flash[:alert] = "Group deleted"
    redirect_to groups_path, alert:"Group destroyed"
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permissions."
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
