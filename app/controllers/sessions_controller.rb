class SessionsController < ApplicationController
  
  def new
  end
  
  
  def create
    user = User.find_by( email: params[ :email ].downcase() )
    
    if user && user.authenticate( params[ :password ] )
      # Sign the user in
      sign_in user
      # redirect to the user page
      redirect_back_or user
    else
      # Create an error message and re-render the signin form
      # use flash.now because render does not count as a request
      # and flash.now does not persist for 1 request
      flash.now[ :error ] = 'Invalid email/password combination'
      render 'new'
    end
    
  end
  
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
end
