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
  sign_in
end
