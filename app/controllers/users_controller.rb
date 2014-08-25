class UsersController < ApplicationController
  # call signed_in_user before executing the edit and update actions
  before_action :signed_in_user, only: [ :edit, :update ]
  # call correct_user before executing the edit and update actions
  before_action :correct_user,   only: [ :edit, :update ]
  
  
  def show
    @user = User.find( params[:id] )
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

  
  private
  
    def user_params()
      params.require( :user ).permit( :name, :email, :password,
                                      :password_confirmation )
    end
    
    
    # before filters
    
    # test if the user is signed in 
    # if not, redirect to the sign in page
    def signed_in_user
      store_location
      redirect_to( signin_url, notice: "Please sign in." ) unless signed_in?
      # equivalent to:
      # unless signed_in?
      #   flash[ :notice ] = "Please sign in."
      #   redirect_to signin_url
      # end
    end
    
    # detect if the correct user is trying
    # to edit the user information
    def correct_user
      @user = User.find( params[:id] )
      redirect_to( root_url ) unless current_user?( @user )
    end
  
end
