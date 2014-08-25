include ApplicationHelper

# helper test method to replace 
#   before do
#     fill_in "Email",    with: user.email.upcase
#     fill_in "Password", with: user.password
#     click_button "Sign in"
#   end 
def valid_signin( user )
  fill_email( user )
  fill_password( user )
  click_sign_in
end

# replaces valid_signin( user )
def sign_in( user, options={} )
  if options[ :no_capybara ]
    # Sign in when not using Capybara
    remember_token = User.new_remember_token
    cookies[ :remember_token ] = remember_token
    user.update_attribute( :remember_token, User.digest( remember_token ) )
  else
    visit signin_path
    fill_email( user )
    fill_password( user )
    click_sign_in
  end
end
