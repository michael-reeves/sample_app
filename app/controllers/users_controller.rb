class UsersController < ApplicationController
  # call signed_in_user before executing the index, edit and update actions
  # this will verify that only signed in users can access these pages
  before_action :signed_in_user, only: [ :index, :edit, :update, :destroy ]
  # call correct_user before executing the edit and update actions
  before_action :correct_user,   only: [ :edit, :update ]
  # call admin_user before executing the destroy action
  before_action :admin_user,     only: :destroy
  # prevent a signed in user from accessing the new and create actions
  before_action :prevent_access, only: [ :new, :create ]
  
  
  def index
    @users = User.paginate( page: params[:page] )
  end
  
  def show
    @user = User.find( params[:id] )
    @microposts = @user.microposts.paginate( page: params[ :page ] )
  end
  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new( user_params() )
    if @user.save()
      sign_in @user     # automatically sign the user in after registration
      flash[ :success ] = "Welcome to the Sample App!"
      redirect_to( @user )
    else
      render 'new'
    end
  end
  
  
  def edit
  end
  
  def update
    if @user.update_attributes( user_params )
      flash[ :success ] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  
  def destroy
    @user = User.find( params[:id] )
    # if the current user tries to delete themselves, redirect to root_url
    if current_user?( @user )
      redirect_to root_url
    else
      @user.destroy
      flash[ :success ] = "User deleted."
      redirect_to users_url
    end
  end
  
  
  private
  
    def user_params()
      params.require( :user ).permit( :name, :email, :password,
                                      :password_confirmation)
    end
    
    
    # before filters
    
    # detect if the correct user is trying
    # to edit the user information
    def correct_user
      @user = User.find( params[:id] )
      redirect_to( root_url ) unless current_user?( @user )
    end
    
    # if anyone other than an admin user attempts to access
    # the destroy action, redirect them to the root page
    def admin_user
      redirect_to( root_url ) unless current_user.admin?
    end
    
    # prevent a signed in user from accesing the new or create actions
    # redirect them to the users index page
    def prevent_access
      redirect_back_or( users_url ) if signed_in?
    end

end
