# coding: utf-8
require 'spec_helper'

describe 'layouts/searches' do
  before do
    affiliate = mock_model(Affiliate,
                           :is_sayt_enabled? => true,
                           :nested_header_footer_css => nil,
                           :header => 'header',
                           :footer => 'footer',
                           :favicon_url => 'http://cdn.agency.gov/favicon.ico',
                           :external_css_url => 'http://cdn.agency.gov/custom.css',
                           :css_property_hash => {},
                           :page_background_image_file_name => nil,
                           :uses_managed_header_footer? => false,
                           :managed_header_css_properties => nil,
                           :show_content_border? => true,
                           :show_content_box_shadow? => true,
                           :connections => [],
                           :locale => 'en',
                           :ga_web_property_id => nil,
                           :external_tracking_code => nil)
    assign(:affiliate, affiliate)
    search = mock(WebSearch, :query => 'america')
    assign(:search, search)
  end

  context 'when SAYT is enabled' do
    before do
      @affiliate = mock_model(Affiliate,
                             :is_sayt_enabled? => true,
                             :nested_header_footer_css => nil,
                             :header => 'header',
                             :footer => 'footer',
                             :favicon_url => 'http://cdn.agency.gov/favicon.ico',
                             :external_css_url => 'http://cdn.agency.gov/custom.css',
                             :css_property_hash => { },
                             :page_background_image_file_name => nil,
                             :uses_managed_header_footer? => false,
                             :managed_header_css_properties => nil,
                             :show_content_border? => true,
                             :show_content_box_shadow? => true,
                             :connections => [],
                             :locale => 'en',
                             :ga_web_property_id => nil,
                             :external_tracking_code => nil)
      assign(:affiliate, @affiliate)
      search = mock(NewsSearch, query: 'america')
      assign(:search, search)
    end

    it 'should have usagov_sayt_url variable' do
      render
      rendered.should contain(%Q{var usagov_sayt_url = "http://test.host/sayt?aid=#{@affiliate.id}&extras=true&";})
    end
  end

  context 'when the en site has a footer' do
    it 'should render Show footer tooltip' do
      render
      rendered.should have_selector(:a, title: 'Show footer')
      rendered.should have_content('Hide footer')
    end
  end

  context 'when the es site has a footer' do
    before { I18n.locale = :es }
    after { I18n.locale = I18n.default_locale }

    it 'should render Mostrar pie de página tooltip' do
      render
      rendered.should have_selector(:a, title: 'Mostrar pie de página')
      rendered.should have_content('Esconder pie de página')
    end
  end
end