require 'spec/spec_helper'

describe Affiliates::HomeController do
  fixtures :users, :affiliates
  before do
    activate_authlogic
  end

  describe "do GET on #index" do
    it "should not require affiliate login" do
      get :index
      response.should be_success
    end
  end

  describe "do GET on #how_it_works" do
    it "should have a title" do
      get :how_it_works
      response.should be_success
    end
  end

  describe "do GET on #demo" do
    it "should have a title" do
      get :demo
      response.should be_success
    end

    it "assigns @affiliate_ads that contains 3 items" do
      get :demo
      assigns[:affiliate_ads].size.should == 3
    end

    it "assigns @affiliate_ads that contains more than 3 items if all parameter is defined" do
      get :demo, :all => ""
      assigns[:affiliate_ads].size.should > 3
    end
  end

  describe "do GET on #new" do
    it "should require affiliate login for new" do
      get :new
      response.should redirect_to(login_path)
    end

    context "when logged in with approved user" do
      before do
        UserSession.create(users(:affiliate_manager_with_no_affiliates))
      end

      it "should assign @title" do
        get :new
        assigns[:title].should_not be_blank
      end

      it "should assign @user" do
        get :new
        assigns[:user].should == users(:affiliate_manager_with_no_affiliates)
      end

      it "should assign @current_step to :edit_contact_information" do
        get :new
        assigns[:current_step].should == :edit_contact_information
      end
    end

    context "when logged in with pending approval user" do
      before do
        UserSession.create(users(:affiliate_manager_with_pending_approval_status))
      end

      it "should redirect to affiliates home page" do
        get :new
        response.should redirect_to(home_affiliates_path)
      end

      it "should set flash[:notice] message" do
        get :new
        flash[:notice].should_not be_blank
      end
    end
  end

  describe "do GET on #edit_site_information" do
    it "should require affiliate login for edit_site_information" do
      get :edit_site_information, :id => affiliates(:power_affiliate).id
      response.should redirect_to(login_path)
    end

    context "when logged in but not an affiliate manager" do
      before do
        UserSession.create(users(:affiliate_admin))
      end

      it "should require affiliate login for edit_site_information" do
        get :edit_site_information, :id => affiliates(:power_affiliate).id
        response.should redirect_to(home_page_path)
      end
    end

    context "when logged in as an affiliate manager who doesn't own the affiliate being edited" do
      before do
        UserSession.create(users(:affiliate_manager))
      end

      it "should redirect to home page" do
        get :edit_site_information, :id => affiliates(:another_affiliate).id
        response.should redirect_to(home_page_path)
      end
    end

    context "when logged in as the affiliate manager" do
      before do
        UserSession.create(users(:affiliate_manager))
      end

      context "when editing one of the affiliate's affiliates" do
        before do
          @affiliate = affiliates(:basic_affiliate)
        end

        it "should assign @title" do
          get :edit_site_information, :id => @affiliate.id
          assigns[:title].should_not be_blank
        end

        it "should assign @affiliate" do
          get :edit_site_information, :id => @affiliate.id
          assigns[:affiliate].should == @affiliate
        end

        it "should sync staged attributes on @affiliate" do
          get :edit_site_information, :id => @affiliate.id
          assigns[:affiliate].staged_domains.should == assigns[:affiliate].domains
          assigns[:affiliate].staged_header.should == assigns[:affiliate].header
          assigns[:affiliate].staged_footer.should == assigns[:affiliate].footer
          assigns[:affiliate].staged_affiliate_template_id.should == assigns[:affiliate].affiliate_template_id
          assigns[:affiliate].staged_search_results_page_title.should == assigns[:affiliate].search_results_page_title
          assigns[:affiliate].has_staged_content.should == false
        end

        it "should render the edit_site_information page" do
          get :edit_site_information, :id => @affiliate.id
          response.should render_template("edit_site_information")
        end
      end
    end
  end

  describe "do POST on #update_site_information" do
    before do
      @affiliate = affiliates(:power_affiliate)
    end

    it "should require affiliate login for update_site_information" do
      post :update_site_information, :id => @affiliate.id, :affiliate=> {}
      response.should redirect_to(login_path)
    end

    context "when logged in as an affiliate manager" do
      before do
        user = users(:affiliate_manager)
        UserSession.create(user)
      end

      it "should assign @affiliate and update @affiliate attributes" do
        post :update_site_information, :id => @affiliate.id, :affiliate=> {:display_name => "new display name"}
        assigns[:affiliate].should == @affiliate
        assigns[:affiliate].display_name.should == "new display name"
      end

      context "when the affiliate update attributes successfully for 'Save for Preview' request" do
        before do
          post :update_site_information, :id => @affiliate.id, :affiliate=> {:display_name => "new display name"}, :commit => "Save for Preview"
        end

        it "should upate the affiliate's staged fields" do
          assigns[:affiliate].has_staged_content.should == true
          assigns[:affiliate].display_name.should == "new display name"
        end

        it "should set a flash[:success] message" do
          flash[:success].should_not be_blank
        end

        it "should redirect to affiliate specific page" do
          response.should redirect_to(affiliate_path(@affiliate))
        end
      end

      context "when the affiliate failed to update attributes for 'Save for Preview' request" do
        before do
         post :update_site_information, :id => @affiliate.id, :affiliate=> { :display_name => nil }, :commit => "Save for Preview"
        end

        it "should assign @title" do
         assigns[:title].should_not be_blank
        end

        it "should redirect to edit site information page" do
         response.should render_template(:edit_site_information)
        end
      end

      context "when the affiliate update attributes successfully for 'Make Live' request" do
        before do
          post :update_site_information, :id => @affiliate.id, :affiliate=> {:display_name => "new display name"}, :commit => "Make Live"
        end

        it "should set a flash[:success] message" do
          flash[:success].should_not be_blank
        end

        it "should redirect to affiliate specific page" do
          response.should redirect_to(affiliate_path(@affiliate))
        end
      end

      context "when the affiliate failed update attributes for 'Make Live' request" do
        before do
          post :update_site_information, :id => @affiliate.id, :affiliate=> {:display_name => nil}, :commit => "Make Live"
        end

        it "should assign @title" do
          assigns[:title].should_not be_blank
        end

        it "should redirect to edit site information  page" do
          response.should render_template(:edit_site_information)
        end
      end
    end
  end

  describe "do GET on #edit_look_and_feel" do
    it "should require affiliate login for edit_look_and_feel" do
      get :edit_look_and_feel, :id => affiliates(:power_affiliate).id
      response.should redirect_to(login_path)
    end

    context "when logged in but not an affiliate manager" do
      before do
        UserSession.create(users(:affiliate_admin))
      end

      it "should require affiliate login for edit_look_and_feel" do
        get :edit_look_and_feel, :id => affiliates(:power_affiliate).id
        response.should redirect_to(home_page_path)
      end
    end

    context "when logged in as an affiliate manager who doesn't own the affiliate being edited" do
      before do
        UserSession.create(users(:affiliate_manager))
      end

      it "should redirect to home page" do
        get :edit_look_and_feel, :id => affiliates(:another_affiliate).id
        response.should redirect_to(home_page_path)
      end
    end

    context "when logged in as the affiliate manager" do
      before do
        UserSession.create(users(:affiliate_manager))
        @affiliate = affiliates(:basic_affiliate)
        get :edit_look_and_feel, :id => affiliates(:basic_affiliate).id
      end

      it "should assign @affiliate" do
        assigns[:affiliate].should == @affiliate
      end

      it "should assign @title" do
        assigns[:title].should_not be_blank
      end

      it "should sync staged attributes on @affiliate" do
        get :edit_look_and_feel, :id => affiliates(:basic_affiliate).id
        assigns[:affiliate].staged_domains.should == assigns[:affiliate].domains
        assigns[:affiliate].staged_header.should == assigns[:affiliate].header
        assigns[:affiliate].staged_footer.should == assigns[:affiliate].footer
        assigns[:affiliate].staged_affiliate_template_id.should == assigns[:affiliate].affiliate_template_id
        assigns[:affiliate].staged_search_results_page_title.should == assigns[:affiliate].search_results_page_title
        assigns[:affiliate].has_staged_content.should == false
      end

      it "should render the edit_look_and_feel page" do
        response.should render_template("edit_look_and_feel")
      end
    end
  end

  describe "do POST on #update_look_and_feel" do
    before do
      @affiliate = affiliates(:power_affiliate)
    end

    it "should require affiliate login for update_look_and_feel" do
      post :update_look_and_feel, :id => @affiliate.id, :affiliate=> {}
      response.should redirect_to(login_path)
    end

    context "when logged in as an affiliate manager" do
      before do
        user = users(:affiliate_manager)
        UserSession.create(user)
      end

      context "when posting" do
        before do
          post :update_look_and_feel, :id => @affiliate.id, :affiliate=> {}
        end

        it "should assign @affiliate" do
          assigns[:affiliate].should == @affiliate
        end
      end

      context "when the affiliate update attributes successfully for 'Save for Preview' request" do
        before do
          post :update_look_and_feel, :id => @affiliate.id, :affiliate=> {:display_name => "new display name"}, :commit => "Save for Preview"
        end

        it "should set a flash[:success] message" do
          flash[:success].should_not be_blank
        end

        it "should redirect to affiliate specific page" do
          response.should redirect_to(affiliate_path(@affiliate))
        end
      end

     context "when the affiliate failed to update attributes for 'Save for Preview' request" do
       before do
         post :update_look_and_feel, :id => @affiliate.id, :affiliate=> {:display_name => nil}, :commit => "Save for Preview"
       end

       it "should assign @title" do
         assigns[:title].should_not be_blank
       end

       it "should redirect to edit site information page" do
         response.should render_template(:edit_look_and_feel)
       end
     end

      context "when the affiliate update attributes successfully for 'Make Live' request" do
        before do
          post :update_look_and_feel, :id => @affiliate.id, :affiliate=> {:display_name => "new display name"}, :commit => "Make Live"
        end

        it "should set a flash[:success] message" do
          flash[:success].should_not be_blank
        end

        it "should redirect to affiliate specific page" do
          response.should redirect_to(affiliate_path(@affiliate))
        end
      end

       context "when the affiliate failed update attributes for 'Make Live' request" do
        before do
          post :update_look_and_feel, :id => @affiliate.id, :affiliate=> {:display_name => nil}, :commit => "Make Live"
        end

        it "should assign @title" do
          assigns[:title].should_not be_blank
        end

        it "should redirect to edit site information  page" do
          response.should render_template(:edit_look_and_feel)
        end
      end

    end
  end

  describe "do POST on #update_contact_information" do
    it "should require login for update_contact_information" do
      post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
      response.should redirect_to(login_path)
    end

    context "when logged in with approved user" do
      before do
        UserSession.create(users(:affiliate_manager_with_no_affiliates))
        User.should_receive(:find_by_id).and_return(users(:affiliate_manager_with_no_affiliates))
      end

      it "should assign @title" do
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
        assigns[:title].should_not be_blank
      end

      it "should assign @user" do
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
        assigns[:user].should == users(:affiliate_manager_with_no_affiliates)
      end

      it "should set strict_mode on user to true" do
        users(:affiliate_manager_with_no_affiliates).should_receive(:strict_mode=).with(true)
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
      end

      it "should update_attributes on user" do
        users(:affiliate_manager_with_no_affiliates).should_receive(:update_attributes)
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
      end

      it "should render the new template" do
        users(:affiliate_manager_with_no_affiliates).should_receive(:update_attributes).and_return(true)
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
        response.should render_template("new")
      end

      context "when the user update_attributes successfully" do
        before do
          users(:affiliate_manager_with_no_affiliates).should_receive(:update_attributes).and_return(true)
        end

        it "should assign @affiliate" do
          affiliate = stub_model(Affiliate)
          Affiliate.should_receive(:new).and_return(affiliate)
          post :update_contact_information
          assigns[:affiliate].should == affiliate
        end

        it "should assign @current_step to :new_site_information" do
          post :update_contact_information
          assigns[:current_step].should == :new_site_information
        end
      end

      context "when the user fails to update_attributes" do
        it "should assign @current_step to :edit_contact_information" do
          users(:affiliate_manager_with_no_affiliates).should_receive(:update_attributes).and_return(false)
          post :update_contact_information
          assigns[:current_step].should == :edit_contact_information
        end
      end
    end

    context "when logged in with pending contact information user" do
      before do
        UserSession.create(users(:affiliate_manager_with_pending_contact_information_status))
        User.should_receive(:find_by_id).and_return(users(:affiliate_manager_with_pending_contact_information_status))
      end

      it "assigns @user" do
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
        assigns[:user].should == users(:affiliate_manager_with_pending_contact_information_status)
      end

      it "sets @user.strict_mode to true" do
        users(:affiliate_manager_with_pending_contact_information_status).should_receive(:strict_mode=).with(true)
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
      end

      it "updates the User attributes" do
        users(:affiliate_manager_with_pending_contact_information_status).should_receive(:update_attributes)
        post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
      end

      context "when the user update attributes successfully" do
        before do
          users(:affiliate_manager_with_pending_contact_information_status).should_receive(:update_attributes).and_return(true)
        end

        it "assigns flash[:success]" do
          post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
          flash[:success].should_not be_blank
        end

        it "redirects to affiliates landing page" do
          post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
          response.should redirect_to(home_affiliates_path)
        end
      end

      context "when the user fails to update_attributes" do
        before do
          users(:affiliate_manager_with_pending_contact_information_status).should_receive(:update_attributes).and_return(false)
          post :update_contact_information, :user => {:email => "changed@foo.com", :contact_name => "BAR"}
        end

        it "renders the affiliates home page" do
          response.should render_template("home")
        end
      end
    end
  end

  describe "do POST on #create" do
    it "should require login for create" do
      post :create
      response.should redirect_to(login_path)
    end

    context "when logged in" do
      before do
        UserSession.create(users(:affiliate_manager_with_no_affiliates))
      end

      it "should assign @title" do
        post :create, :affiliate => {:display_name => 'new_affiliate'}
        assigns[:title].should_not be_blank
      end

      it "should assign @affiliate" do
        post :create, :affiliate => {:display_name => 'new_affiliate'}
        assigns[:affiliate].should_not be_nil
      end

      it "should save the affiliate" do
        post :create, :affiliate => {:display_name => 'new_affiliate'}
        assigns[:affiliate].id.should_not be_nil
      end

      context "when the affiliate saves successfully" do
        before do
          @emailer = mock(Emailer)
          @emailer.stub!(:deliver).and_return true
        end

        it "should assign @current_step to :get_code" do
          post :create, :affiliate => {:display_name => 'new_affiliate'}
          assigns[:current_step].should == :get_the_code
        end

        it "should email the affiliate a confirmation email" do
          Emailer.should_receive(:new_affiliate_site).and_return @emailer
          post :create, :affiliate => {:display_name => 'new_affiliate'}
        end

        it "should render the new template" do
          post :create, :affiliate => {:display_name => 'new_affiliate'}
          response.should render_template("new")
        end
      end

      context "when the affiliate fails to save" do
        it "should assign @current_step to :new_site_information" do
          post :create
          assigns[:current_step].should == :new_site_information
        end

        it "should not send an email" do
          Emailer.should_not_receive(:new_affiliate_site)
          post :create
        end

        it "should render the new template" do
          post :create
          response.should render_template("new")
        end
      end
    end
  end

  describe "do POST on #push_content_for" do
    before do
      @affiliate = affiliates(:power_affiliate)
      @affiliate.update_attributes(:has_staged_content => true)
    end

    context "when not logged in" do
      before do
        post :push_content_for, :id => @affiliate.id
      end

      it "should require affiliate login for push_content_for" do
        response.should redirect_to(login_path)
      end
    end

    context "when logged in as an affiliate manager" do
      before do
        user = users(:affiliate_manager)
        UserSession.create(user)
        post :push_content_for, :id => @affiliate.id
      end

      it "should assign @affiliate" do
        assigns[:affiliate].should == @affiliate
      end

      it "should update @affiliate attributes for current" do
        assigns[:affiliate].has_staged_content.should == false
      end

      it "should redirect to affiliate specific page" do
        response.should redirect_to affiliate_path(@affiliate)
      end
    end
  end

  describe "do POST on #cancel_staged_changes_for" do
    before do
      @affiliate = affiliates(:power_affiliate)
    end

    context "when not logged in" do
      before do
        post :cancel_staged_changes_for, :id => @affiliate.id
      end

      it "should require affiliate login for cancel_staged_changes_for" do
        response.should redirect_to(login_path)
      end
    end

    context "when logged in as an affiliate manager" do
      before do
        user = users(:affiliate_manager)
        user.affiliates.include?(@affiliate).should be_true
        session = UserSession.create(user)
        post :cancel_staged_changes_for, :id => @affiliate.id
      end

      it "should assign @affiliate" do
        assigns[:affiliate].should == @affiliate
      end

      it "should update @affiliate attributes for current" do
        assigns[:affiliate].staged_domains.should == "nga.mil\nusa.gov\nnoaa.gov"
        assigns[:affiliate].staged_header.should == assigns[:affiliate].header
        assigns[:affiliate].staged_footer.should == assigns[:affiliate].footer
        assigns[:affiliate].staged_affiliate_template_id.should == assigns[:affiliate].affiliate_template_id
        assigns[:affiliate].staged_search_results_page_title.should == assigns[:affiliate].search_results_page_title
        assigns[:affiliate].has_staged_content.should == false
      end

      it "should redirect to affiliate specific page" do
        response.should redirect_to affiliate_path(@affiliate)
      end
    end
  end

  describe "do GET on #preview" do
    it "should require affiliate login for preview" do
      get :preview, :id => affiliates(:power_affiliate).id
      response.should redirect_to(login_path)
    end

    context "when logged in but not an affiliate manager" do
      before do
        UserSession.create(users(:affiliate_admin))
      end

      it "should require affiliate login for preview" do
        get :preview, :id => affiliates(:power_affiliate).id
        response.should redirect_to(home_page_path)
      end
    end

    context "when logged in as an affiliate manager who doesn't own the affiliate being previewed" do
      before do
        UserSession.create(users(:affiliate_manager))
      end

      it "should redirect to home page" do
        get :preview, :id => affiliates(:another_affiliate).id
        response.should redirect_to(home_page_path)
      end
    end

    context "when logged in as the affiliate manager" do
      render_views
      before do
        UserSession.create(users(:affiliate_manager))
      end

      it "should assign @title" do
        get :preview, :id => affiliates(:basic_affiliate).id
        assigns[:title].should_not be_blank
      end

      it "should render the preview page" do
        get :preview, :id => affiliates(:basic_affiliate).id
        response.should render_template("preview")
      end
    end
  end

  describe "do GET on #best_bets" do
    context "when not logged in" do
      before do
        get :best_bets, :id => affiliates(:power_affiliate).id
      end

      it { should redirect_to login_path }
    end

    context "when logged in but not an affiliate manager" do
      before do
        UserSession.create(users(:affiliate_admin))
        get :best_bets, :id => affiliates(:power_affiliate).id
      end

      it { should redirect_to home_page_path }
    end

    context "when logged in as an affiliate manager who doesn't own the affiliate being previewed" do
      before do
        UserSession.create(users(:affiliate_manager))
        get :best_bets, :id => affiliates(:another_affiliate).id
      end

      it { should redirect_to home_page_path }
    end

    context "when logged in as the affiliate manager" do
      let(:affiliate) { affiliates(:basic_affiliate) }
      let(:current_user) { users(:affiliate_manager) }
      let(:boosted_contents) { mock('Boosted Contents') }
      let(:recent_boosted_contents) { mock('recent Boosted Contents') }
      let(:featured_collections) { mock('Featured Collections') }
      let(:recent_featured_collections) { mock('recent Featured Collections') }

      before do
        UserSession.create(current_user)
        User.should_receive(:find_by_id).and_return(current_user)

        current_user.stub_chain(:affiliates, :find).and_return(affiliate)

        affiliate.should_receive(:boosted_contents).and_return(boosted_contents)
        boosted_contents.should_receive(:recent).and_return(recent_boosted_contents)

        affiliate.should_receive(:featured_collections).and_return(featured_collections)
        featured_collections.should_receive(:recent).and_return(recent_featured_collections)

        get :best_bets, :id => affiliates(:basic_affiliate).id
      end

      it { should assign_to :title }
      it { should assign_to(:boosted_contents).with(recent_boosted_contents) }
      it { should assign_to(:featured_collections).with(recent_featured_collections) }
      it { should respond_with(:success) }
    end
  end
end
