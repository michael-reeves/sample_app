include ApplicationHelper

# helper test method to replace 
#   before do
#     fill_in "Email",    with: user.email.upcase
#     fill_in "Password", with: user.password
#     click_button "Sign in"
#   end 
def valid_signin( user )
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end


# a custom 'matcher' for the should clause
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect( page ).to have_selector( 'div.alert.alert-error', text: message )
  end
end
