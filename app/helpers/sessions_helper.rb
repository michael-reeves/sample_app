module SessionsHelper
  
  def sign_in( user )
    # create a new remember_token
    remember_token = User.new_remember_token
    # store the token in a cookie in the user's browser
    cookies.permanent[ :remember_token ] = remember_token
    # store a hashed version of the token in the database
    user.update_attribute( :remember_token, User.digest( remember_token ) )
    # set the current user to the modified User
    self.current_user = user
  end
  
  
  # determine if the user is signed in (not nil)
  def signed_in?()
    !current_user.nil?
  end
  
  
  def current_user=( user )
    @current_user = user
  end
  
  
  def current_user()
    # HTTP is stateless, so we need to lookup the current user
    # based on the cookie that was stored in their browser,
    # then hash that and find the matching user in the DB.
    remember_token = User.digest( cookies[ :remember_token ] )
    @current_user ||= User.find_by( remember_token: remember_token )
  end
  
  
  def current_user?( user )
    user == current_user
  end
  
  
  # test if the user is signed in 
  # if not, redirect to the sign in page
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to( signin_url, notice: "Please sign in." )
    end
  end


  def sign_out
    # change the token in the db to prevent stolen 
    # cookies from providing access
    current_user.update_attribute( :remember_token, 
                                   User.digest( User.new_remember_token() ) )
    # delete the cookie in the user's browser
    cookies.delete( :remember_token )
    # set the user to nil
    self.current_user = nil
    # remove the return to session variable
    session.delete( :return_to )
  end
  
  
  # redirect to the previous page, or to the default page
  def redirect_back_or( default )
    redirect_to( session[ :return_to ] || default )
    session.delete( :return_to )
  end
  
  # store the location of the requested url
  def store_location
    session[ :return_to ] = request.url if request.get?
  end
  
end
