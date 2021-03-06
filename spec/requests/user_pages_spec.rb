require 'spec_helper'

describe "UserPages" do
  
  subject { page }
  
  describe "index" do
    let( :user ) { FactoryGirl.create( :user ) }
    
    before( :each ) do
      sign_in user 
      visit users_path
    end
    
    it { should have_title( 'All users' ) }
    it { should have_content( 'All users' ) }
    
    describe "pagination" do
      # create 30 users once before all the tests in the block
      # and then delete them when this section is complete
      before( :all ) { 30.times {FactoryGirl.create( :user ) } }
      after(  :all ) { User.delete_all }
      
      it { should have_selector('div.pagination') }

      it "should list each user" do
        # pull the first page of users from the database
        User.paginate(page: 1).each do |user|
          expect( page ).to have_selector( 'li', text: user.name )
        end
        
      end
      
    end
    
    # test the delete links on the index page
    describe "delete links" do
      
      # regular user should not be able to see the delete links
      it { should_not have_link( 'delete' ) }
      
      describe "as an admin user" do
        let( :admin ) { FactoryGirl.create( :admin ) }
        before do
          sign_in admin
          visit users_path
        end
        
        # admin users should be able to see a delete link
        # and delete other users, but not themselves
        it { should have_link( 'delete',  href: user_path( User.first ) ) }
        it "should be able to delete another user" do
          expect do
            click_link( 'delete', match: :first )
          end.to change( User, :count ).by( -1 )
        end
        it { should_not have_link( 'delete', href: user_path( admin ) ) }
      end
      
    end
    
  end
  
  
  # test the show page
  describe "profile page" do
    let( :user ) { FactoryGirl.create( :user ) }
    let!( :m0 ) do
      50.times do
        content = Faker::Lorem.sentence(5)
        FactoryGirl.create( :micropost, user: user, content: content )
      end
    end
    let!( :m1 ) { FactoryGirl.create( :micropost, user: user, content: "Foo" ) }
    let!( :m2 ) { FactoryGirl.create( :micropost, user: user, content: "Bar" ) }

    before { visit user_path( user ) }
    
    it { should have_content( user.name ) }
    it { should have_title( user.name ) }

    describe "micropost" do
      it { should have_content( m1.content ) }
      it { should have_content( m2.content ) }
      it { should have_content( user.microposts.count ) }

      describe "pagination" do
        
        it { should have_selector( 'div.pagination') }

        it "should render the user's feed" do
          user.feed.paginate( page: 1 ).each do |item|
            expect( page ).to have_selector( "li##{item.id}", text: item.content )
          end
        end
      end
    end
  end

  describe "signup page" do
    before { visit signup_path }
    
    it { should have_content( "Sign up" ) }
    it { should have_title( full_title( 'Sign up' ) )  }
  end
  
  
  # test signup form submission
  describe "signup" do
    before { visit signup_path }
    
    let( :submit ) { "Create my account" }
    
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change( User, :count )
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_title( 'Sign up' ) }
        it { should have_content( 'error' ) }
        it { should have_content( "Name can't be blank" ) }
        it { should have_content( "Email can't be blank" ) }
        it { should have_content( "Email is invalid" ) }
        it { should have_content( "Password can't be blank" ) }
        it { should have_content( "Password is too short" ) }
        it { should_not have_link( 'Profile' ) }
        it { should_not have_link( 'Settings' ) }
      end
      
      describe "after submission with password mismatch" do
        before do
          fill_signup_with_password_mismatch
          click_button submit
        end
      
        it { should have_title( 'Sign up' ) }
        it { should have_content( 'error' ) }
        it { should have_content( "doesn't match") }
      end
      
    end
    
    
    describe "with valid information" do
      before { fill_signup_with_valid_data }
      
      it "should create a user" do
        expect { click_button submit }.to change( User, :count ).by(1)
      end
      
      describe "after saving the user" do
        before{ click_button submit }
        let( :user ) { User.find_by( email: "user@example.com" ) }
        
        it { should have_link( 'Sign out' ) }
        it { should have_title( user.name ) }
        #it { should have_selector( 'div.alert.alert-success', text: 'Welcome' ) }
        it { should have_message( 'Welcome' ) }
      end

    end
    
  end
  
  
  describe "edit" do
    let( :user ) { FactoryGirl.create( :user ) }
    before do
      sign_in user
      visit edit_user_path( user )
    end
    
    describe "page" do
      it { should have_content( 'Update your profile' ) }
      it { should have_title( 'Edit user' ) }
      it { should have_link( 'change', href: 'http://gravatar.com/emails' ) }
    end
    
    describe "with invalid information" do
      before { click_button "Save changes" }
      
      it { should have_content( 'error' ) }
    end
    
    describe "with valid information" do
      let( :new_name )  { "New Name" }
      let( :new_email ) { "new@example.com" }
      
      before do
        fill_in "Name",      with: new_name
        fill_in "Email",     with: new_email
        fill_in "Password",  with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      
      it { should have_title( new_name ) }
      it { should have_selector( 'div.alert.alert-success' ) }
      it { should have_link( 'Sign out', href: signout_path ) }
      specify { expect( user.reload.name ).to  eq new_name }
      specify { expect( user.reload.email ).to eq new_email }
    end
    
    # verify that the admin parameter is not accessible directly
    describe "forbidden attributes" do
      let( :params ) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      
      before do
        sign_in( user, no_capybara: true )
        # pass the parameter list directly to a PATCH request
        patch user_path( user ), params
      end
      
      specify { expect( user.reload ).not_to be_admin }
      
    end
    
  end
  
end
