# data to use to fill in the various form fields

def fill_name
  fill_in "Name",         with: "Example User" 
end

def fill_email( user = nil )
  if user
    fill_in "Email",      with: user.email
  else
    fill_in "Email",      with: "user@example.com"
  end
end

def fill_password( user = nil )
  if user
    fill_in "Password",   with: user.password
  else
    fill_in "Password",   with: "foobar"
  end 
end

def fill_confirmation 
  fill_in "Confirmation", with: "foobar" 
end

def fill_mismatch 
  fill_in "Confirmation", with: "barbaz" 
end


def fill_signup_form( type )
  fill_name
  fill_email
  fill_password
  
  if type == 'valid'
    fill_confirmation
  elsif type == 'mismatch'
    fill_mismatch
  end 

end

def fill_signup_with_valid_data
  fill_signup_form( 'valid' )
end

def fill_signup_with_password_mismatch
  fill_signup_form( 'mismatch' )
end