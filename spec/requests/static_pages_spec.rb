require 'spec_helper'

describe "StaticPages" do
  
  subject { page }
  
  # define common tests for all static pages
  shared_examples_for( 'all static pages' ) do
    it { should have_selector( 'h1', text: heading ) }
    it { should have_title( full_title( page_title ) ) }
  end
  
  
  # test the heading and title of the Home page
  describe "Home page" do
    before { visit( root_path ) }
    let( :heading )    { 'Sample App' }
    let( :page_title ) { '' }
    
    it_should_behave_like 'all static pages'
    it { should_not have_title( "| Home" ) }

    describe "for signed-in users" do
      let( :user ) { FactoryGirl.create( :user ) }
      before do
        50.times do
          content = Faker::Lorem.sentence(5)
          FactoryGirl.create( :micropost, user: user, content: content )
        end
        # FactoryGirl.create( :micropost, user: user, content: "Lorem ipsum" )
        # FactoryGirl.create( :micropost, user: user, content: "Dolor sit amet" )
        sign_in user
        visit root_path
      end

      describe "micropost" do
        it "should paginate" do
          expect( page ).to have_selector( 'div.pagination' )
        end

        it "should render the user's feed" do
          user.microposts.paginate( page: 1 ).each do |item|
          # user.feed.each do |item|
            expect( page ).to have_selector( "li##{item.id}", text: item.content )
          end
        end

        describe "count" do
          it { should have_content( user.feed.count ) }
          it { should have_content( 'microposts' ) }

          describe "when there is only one post" do
            before do
              user.microposts.delete_all
              FactoryGirl.create( :micropost, user: user, content: "Lorem ipsum" )
            end

            it { should have_content( 'micropost' ) }
          end
        end

      end

    end
  end
  
  
  # test the heading and title of the Help page
  describe "Help page" do
    before { visit help_path }
    let( :heading )    { 'Help' }
    let( :page_title ) { 'Help' }
    
    it_should_behave_like 'all static pages'
  end
  
  
  # test the heading and title of the About page
  describe "About page" do
    before { visit about_path }
    let( :heading )    { "About Us" }
    let( :page_title ) { "About Us" }
    
    it_should_behave_like 'all static pages'
  end
  
  
  # test the heading and title of the Contact page
  describe "Contact page" do
    before { visit contact_path }
    let( :heading )    { "Contact" }
    let( :page_title ) { "Contact" }
    
    it_should_behave_like 'all static pages'
  end
  
  
  # check the links in the layout
  it "should have the right links on the layout" do
    visit root_path
    
    click_link "About"
    expect( page ).to have_title( full_title( 'About Us' ) )
    
    click_link "Help"
    expect( page ).to have_title( full_title( 'Help' ) )
    
    click_link "Contact"
    expect( page ).to have_title( full_title( 'Contact' ) )
    
    click_link "Home"
    click_link "Sign up now!"
    expect( page ).to have_title( full_title( 'Sign up' ) )
    
    click_link "sample app"
    expect( page ).to have_title( full_title( '' ) )
    
  end
  
end
