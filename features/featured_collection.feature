@featured_collection
Feature: Featured Collections
  As a USAAdmin
  I want to manage feature collections
  So that I can share them with my search users

  Scenario: Visiting Featured Collections index page
    Given the following featured collections exist:
      | title                                                                 | title_url                      | locale | status | publish_start_on | publish_end_on |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit cras posuere. | http://agency.usa.gov/content5 | en     | active | 07/01/2011       | 07/01/2012     |
    Given the following featured collections exist for the affiliate "noaa.gov":
      | title                         | locale | status |
      | Affiliate featured collection | en     | active |
    And the following featured collection keywords exist for featured collection titled "Lorem ipsum dolor sit amet, consectetur adipiscing elit cras posuere.":
      | value |
      | muspi |
      | merol |
    And I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin home page
    And I follow "Search.USA.gov Featured Collections"
    Then I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections
    And I should see "Search.USA.gov Featured Collections" in the page header
    And I should see "Add new featured collection"
    And I should see "Lorem ipsum dolor sit amet, consectetur adipiscing elit cras..."
    And I should see "07/01/2011"
    And I should see "07/01/2012"
    And I should see "Active"
    And I should not see "Affiliate featured collection"
    When there are 30 featured collections exist with the following attributes:
      | locale | status |
      | en     | active |
    And I go to the admin featured collections page
    Then I should see "20" featured collections
    When I follow "Next"
    Then I should see "random title 20"

  Scenario: Adding Featured Collection
    Given I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin featured collections page
    Then I should see "Search.USA.gov has no Featured Collection"
    When I follow "Add new featured collection"
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections > Add a new Featured Collection
    And I should see "Add a new Featured Collection" in the page header
    When I follow "Cancel"
    Then I should see "Search.USA.gov Featured Collections" in the page header

    When I follow "Add new featured collection"
    And I fill in the following:
      | Title*                | 2010 Atlantic Hurricane Season                    |
      | Title URL             | http://www.nhc.noaa.gov/2010atlan.shtml           |
      | Publish start date    | 07/01/2011                                        |
      | Publish end date      | 07/01/2012                                        |
      | Keyword 0             | weather                                           |
      | Image alt text        | hurricane logo                                    |
      | Image attribution     | NOAA                                              |
      | Image attribution url | http://www.noaa.gov/hurricane.html                |
      | Link Title 0          | Hurricane Alex                                    |
      | Link URL 0            | http://www.nhc.noaa.gov/pdf/TCR-AL012010_Alex.pdf |
    And I attach the file "features/support/small.jpg" to "Image"
    And I select "English" from "Locale*"
    And I select "Active" from "Status*"
    And I select "One column" from "Layout*"
    And I press "Add"
    Then I should see "Featured Collection successfully created"
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections > Featured Collection
    And I should see "Featured Collection" in the page header
    And I should see "2010 Atlantic Hurricane Season"
    And I should see "http://www.nhc.noaa.gov/2010atlan.shtml"
    And I should see "English"
    And I should see "Active"
    And I should see "07/01/2011"
    And I should see "07/01/2012"
    And I should see "One column"
    And I should see "weather"
    And I should see an image with alt text "hurricane logo"
    And I should see "hurricane logo"
    And I should see "NOAA"
    And I should see "http://www.noaa.gov/hurricane.html"
    And I should see a link to "Hurricane Alex" with url for "http://www.nhc.noaa.gov/pdf/TCR-AL012010_Alex.pdf"
    When I follow "Edit"
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections > Edit Featured Collection
    And I should see "Edit Featured Collection" in the page header
    And the "Title*" field should contain "2010 Atlantic Hurricane Season"
    And the "Title URL" field should contain "http://www.nhc.noaa.gov/2010atlan.shtml"
    And the "Keyword 0" field should contain "weather"

    When I go to the homepage
    And I fill in "query" with "hurricane"
    And I press "Search"
    Then I should see "2010 Atlantic Hurricane Season by USA.gov" in the featured collections section

  Scenario: Validating Featured Collection on create
    When I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    And I go to the admin featured collections page
    And I follow "Add new featured collection"
    And I fill in the following:
      | Publish start date | 07/01/2012                              |
      | Publish end date   | 07/01/2011                              |
      | Link Title 0       | 2010 Atlantic Hurricane Season          |
      | Link URL 1         | http://www.nhc.noaa.gov/2010atlan.shtml |
    And I attach the file "features/support/very_large.jpg" to "Image"
    And I press "Add"
    Then I should see "Title can't be blank"
    And I should see "Locale must be selected"
    And I should see "Status must be selected"
    And I should see "Layout must be selected"
    And I should see "One or more keywords are required"
    And I should see "Publish end date can't be before publish start date"
    And I should see "Image file size must be under 512 KB"
    And I should see "Featured collection links title can't be blank"
    And I should see "Featured collection links url can't be blank"

    When I attach the file "features/support/not_image.txt" to "Image"
    And I press "Add"
    Then I should see "Image content type must be GIF, JPG, or PNG"

  Scenario: Editing Featured Collection
    Given the following featured collections exist:
      | title                            | title_url                                | locale | status | layout     |
      | Worldwide Tropical Cyclone Names | http://www.nhc.noaa.gov/aboutnames.shtml | en     | active | one column |
    And the following featured collection keywords exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | value        |
      | weather      |
      | hurricane    |
      | thunderstorm |
    And the following featured collection links exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | title                 | url                                          |
      | Atlantic              | http://www.nhc.noaa.gov/aboutnames.shtml#atl |
      | Eastern North Pacific | http://www.nhc.noaa.gov/aboutnames.shtml#enp |
    And I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin featured collections page
    And I follow "Edit"
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections > Edit Featured Collection
    And I should see "Edit Featured Collection" in the page header
    And the "Title*" field should contain "Worldwide Tropical Cyclone Names"
    And the "Title URL" field should contain "http://www.nhc.noaa.gov/aboutnames.shtml"
    And the "Locale*" field should contain "en"
    And the "Status*" field should contain "active"
    And the "Layout*" field should contain "one column"

    When I follow "Cancel"
    Then I should see "Featured Collection" in the page header

    When I follow "Edit"
    And I fill in the following:
      | Title        | Australian Tropical Cyclone                                                                                |
      | Title URL    | http://australiasevereweather.com/cyclones/                                                                |
      | Keyword 0    | typhoon                                                                                                    |
      | Keyword 1    | cyclone                                                                                                    |
      | Keyword 2    |                                                                                                            |
      | Link Title 0 | 2010-2011 Season Southern Hemisphere Summary                                                               |
      | Link URL 0   | http://australiasevereweather.com/tropical_cyclones/oper_2010_2011_australian_region_tropical_cyclones.htm |
      | Link Title 1 |                                                                                                            |
      | Link URL 1   |                                                                                                            |
    And I select "Two column" from "Layout*"
    And I press "Update"
    Then I should see "Featured Collection successfully updated."
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections > Featured Collection
    And I should see "Featured Collection" in the page header
    And I should see "Two column"
    And I should see "typhoon"
    And I should see "cyclone"
    And I should not see "thunderstorm"
    And I should see a link to "2010-2011 Season Southern Hemisphere Summary" with url for "http://australiasevereweather.com/tropical_cyclones/oper_2010_2011_australian_region_tropical_cyclones.htm"
    And I should not see "Atlantic"
    And I should not see "Eastern North Pacific"

  Scenario: Deleting a featured collection image
    Given the following featured collections exist:
      | title                            | title_url                                | locale | status |
      | Worldwide Tropical Cyclone Names | http://www.nhc.noaa.gov/aboutnames.shtml | en     | active |
    And the following featured collection keywords exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | value        |
      | weather      |
    And I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin featured collections page
    And I follow "Edit"
    And I fill in "Image alt text" with "tornado & hurricane"
    And I attach the file "features/support/small.jpg" to "Image"
    And I press "Update"
    Then I should see an image with alt text "tornado & hurricane"
    When I follow "Edit"
    And I check "Mark image for deletion"
    And I press "Update"
    Then I should not see an image with alt text "tornado & hurricane"

  Scenario: Validating Featured Collection on update
    Given the following featured collections exist:
      | title                            | title_url                                | locale | status |
      | Worldwide Tropical Cyclone Names | http://www.nhc.noaa.gov/aboutnames.shtml | en     | active |
    And the following featured collection keywords exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | value        |
      | weather      |
      | hurricane    |
      | thunderstorm |
    And the following featured collection links exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | title                 | url                                          |
      | Atlantic              | http://www.nhc.noaa.gov/aboutnames.shtml#atl |
      | Eastern North Pacific | http://www.nhc.noaa.gov/aboutnames.shtml#enp |
    And I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin featured collections page
    And I follow "Edit"
    And I fill in the following:
      | Title              |            |
      | Publish start date | 07/01/2012 |
      | Publish end date   | 07/01/2011 |
      | Keyword 0          |            |
      | Keyword 1          |            |
      | Keyword 2          |            |
      | Link Title 0       |            |
      | Link URL 1         |            |
    And I select "Select a locale" from "Locale*"
    And I select "Select a status" from "Status*"
    And I select "Select a layout" from "Layout*"
    And I attach the file "features/support/very_large.jpg" to "Image"
    And I press "Update"
    Then I should see "Title can't be blank"
    And I should see "Locale must be selected"
    And I should see "Status must be selected"
    And I should see "Layout must be selected"
    And I should see "Publish end date can't be before publish start date"
    And I should see "One or more keywords are required"
    And I should see "Image file size must be under 512 KB"
    And I should see "Featured collection links title can't be blank"
    And I should see "Featured collection links url can't be blank"

    When I attach the file "features/support/not_image.txt" to "Image"
    And I press "Update"
    Then I should see "Image content type must be GIF, JPG, or PNG"

  Scenario: Deleting Featured Collection from the index page
    Given the following featured collections exist:
      | title                                                                                                      | title_url                | locale | status   |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis at tincidunt erat. Sed sit amet massa massa. | http://site.gov/content5 | en     | active   |
    And I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin featured collections page
    And I press "Delete"
    Then I should see "Featured Collection successfully deleted"
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections
    And I should see "Featured Collections" in the page header

  Scenario: Deleting Featured Collection from the individual featured collection page
    Given the following featured collections exist:
      | title                                                                            | title_url                | locale | status |
      | Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis at tincidunt erat. | http://site.gov/content5 | en     | active |
    And I am logged in with email "affiliate_admin@fixtures.org" and password "admin"
    When I go to the admin featured collections page
    And I follow "Lorem ipsum dolor sit amet"
    And I press "Delete"
    Then I should see "Featured Collection successfully deleted"
    And I should see the following breadcrumbs: USASearch > Search.USA.gov > Admin Center > Search.USA.gov Featured Collections
    And I should see "Featured Collections" in the page header

  Scenario: Search.USA.gov user sees featured collection with an image
    Given the following featured collections exist:
      | title                            | title_url                                | locale | status | image_file_name | image_alt_text | image_attribution | image_attribution_url |
      | Worldwide Tropical Cyclone Names | http://www.nhc.noaa.gov/aboutnames.shtml | en     | active | cyclone.jpg     | cyclone image  | NOAA              | http://www.noaa.gov   |
    And the following featured collection keywords exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | value        |
      | weather      |
      | hurricane    |
      | thunderstorm |
    And the following featured collection links exist for featured collection titled "Worldwide Tropical Cyclone Names":
      | title                 | url                                          |
      | Atlantic              | http://www.nhc.noaa.gov/aboutnames.shtml#atl |
      | Eastern North Pacific | http://www.nhc.noaa.gov/aboutnames.shtml#enp |
    When I go to the homepage
    And I fill in "query" with "Worldwide"
    And I press "Search"
    Then I should see a link to "Worldwide Tropical Cyclone Names" with url for "http://www.nhc.noaa.gov/aboutnames.shtml" in the featured collections section
    And I should see a featured collection image section
    And I should see an image with alt text "cyclone image" in the featured collections section
    And I should see a link to "NOAA" with url for "http://www.noaa.gov" in the featured collections section
    And I should see a link to "Atlantic" with url for "http://www.nhc.noaa.gov/aboutnames.shtml#atl" in the featured collections section
    And I should see a link to "Eastern North Pacific" with url for "http://www.nhc.noaa.gov/aboutnames.shtml#enp" in the featured collections section

  Scenario: Search.USA.gov user sees featured collection without an image
    Given the following featured collections exist:
      | title                            | title_url                                | locale | status | image_file_name | image_content_type | image_file_size | image_updated_at |
      | Worldwide Tropical Cyclone Names | http://www.nhc.noaa.gov/aboutnames.shtml | en     | active |                 |                    |                 |                  |
    When I go to the homepage
    And I fill in "query" with "Worldwide"
    And I press "Search"
    Then I should see a link to "Worldwide Tropical Cyclone Names" with url for "http://www.nhc.noaa.gov/aboutnames.shtml" in the featured collections section
    And I should not see a featured collection image section

  Scenario: Search.USA.gov user should see featured collection within publish date range
    Given the following featured collections exist:
      | title                                                | locale | status | publish_start_on | publish_end_on |
      | featured collection with publish_start_date          | en     | active | yesterday        |                |
      | featured collection with publish_start_and_end_dates | en     | active | yesterday        | next_month     |
      | featured collection with publish_end_date            | en     | active |                  | next_month     |
    When I go to the homepage
    And I fill in "query" with "publish_start_date"
    And I press "Search"
    Then I should see "featured collection with publish_start_date"
    When I fill in "query" with "publish_start_and_end_dates"
    And I press "Search"
    Then I should see "featured collection with publish_start_and_end_dates"
    When I fill in "query" with "publish_end_date"
    And I press "Search"
    Then I should see "featured collection with publish_end_date"

  Scenario: Search.USA.gov user should not see featured collection outside publish date range
    Given the following featured collections exist:
      | title                        | locale | status | publish_start_on | publish_end_on |
      | expired1 featured collection | en     | active |                  | yesterday      |
      | expired2 featured collection | en     | active | prev_month       | yesterday      |
      | future1 featured collection  | en     | active | tomorrow         | next_month     |
      | future2 featured collection  | en     | active | tomorrow         |                |
    When I go to the homepage
    And I fill in "query" with "expired1"
    And I press "Search"
    Then I should not see "expired1 featured collection"
    When I fill in "query" with "expired2"
    And I press "Search"
    Then I should not see "expired2 featured collection"
    When I fill in "query" with "future1"
    And I press "Search"
    Then I should not see "future1 featured collection"
    When I fill in "query" with "future2"
    And I press "Search"
    Then I should not see "future2 featured collection"

  Scenario: Search.USA.gov user should see featured collections with high weight
    Given the following featured collections exist:
      | title                   | locale | status |
      | high 1 weight           | en     | active |
      | high 2 weight           | en     | active |
      | lower 1 with link title | en     | active |
    And the following featured collection links exist for featured collection titled "lower 1 with link title":
      | title          | url                     |
      | lower 1 weight | http://www.agency.org/1 |
    When I go to the homepage
    And I fill in "query" with "weight"
    And I press "Search"
    Then I should see "high 1 weight" in the featured collections section
    And I should see "high 2 weight" in the featured collections section
    And I should not see "lower 1" in the featured collections section

  Scenario: Search.USA.gov user should see featured collections with lower weight
    Given the following featured collections exist:
      | title                   | locale | status |
      | lowest 1 with keywords  | en     | active |
      | lower 1 with link title | en     | active |
      | lower 2 with link title | en     | active |
    And the following featured collection keywords exist for featured collection titled "lowest 1 with keywords":
      | value           |
      | lowest weight 1 |
    And the following featured collection links exist for featured collection titled "lower 1 with link title":
      | title          | url                     |
      | lower weight 1 | http://www.agency.org/1 |
    And the following featured collection links exist for featured collection titled "lower 2 with link title":
      | title          | url                     |
      | lower weight 2 | http://www.agency.org/2 |
    And all featured collections are indexed
    When I go to the homepage
    And I fill in "query" with "weight"
    And I press "Search"
    Then I should see "lower 1" in the featured collections section
    And I should see "lower 2" in the featured collections section
    And I should not see "lowest 1" in the featured collections section

  Scenario: Search.USA.gov user should see featured collections with lowest weight
    Given the following featured collections exist:
      | title                   | locale | status |
      | lower 1 with link title | en     | active |
      | lowest 1 with keywords  | en     | active |
      | lowest 2 with keywords  | en     | active |
    And the following featured collection keywords exist for featured collection titled "lowest 1 with keywords":
      | value           |
      | lowest weight 1 |
    And the following featured collection keywords exist for featured collection titled "lowest 2 with keywords":
      | value           |
      | lowest weight 2 |
    And the following featured collection links exist for featured collection titled "lower 1 with link title":
      | title   | url                     |
      | lower 1 | http://www.agency.org/1 |
    And all featured collections are indexed
    When I go to the homepage
    And I fill in "query" with "weight"
    And I press "Search"
    Then I should see "lowest 1" in the featured collections section
    And I should see "lowest 2" in the featured collections section
    And I should not see "lower 1" in the featured collections section

  Scenario: Search.USA.gov user should see featured collections with highlighted title and link titles
    Given the following featured collections exist:
      | title            | title_url                                       | locale | status |
      | Nature & Science | http://www.nps.gov/maca/naturescience/index.htm | en     | active |
    And the following featured collection links exist for featured collection titled "Nature & Science":
      | title                         | url                                                                    |
      | Animals                       | http://www.nps.gov/maca/naturescience/animals.htm                      |
      | Environmental Factors         | http://www.nps.gov/maca/naturescience/environmentalfactors.htm         |
      | Plants                        | http://www.nps.gov/maca/naturescience/plants.htm                       |
      | Natural Features & Ecosystems | http://www.nps.gov/maca/naturescience/naturalfeaturesandecosystems.htm |
    And all featured collections are indexed
    When I go to the homepage
    And I fill in "query" with "Nature"
    And I press "Search"
    Then I should see a featured collection title with "Nature" highlighted
    And I should see a featured collection link title with "Natural" highlighted

    When I fill in "query" with "Animal and Plant"
    And I press "Search"
    Then I should see a featured collection link title with "Animals" highlighted
    And I should see a featured collection link title with "Plants" highlighted

  Scenario: Search.USA.gov Spanish user sees featured collection
    Given the following featured collections exist:
      | title                                           | title_url                                | locale | status | image_file_name | image_alt_text | image_attribution | image_attribution_url |
      | Nombres de ciclones tropicales en todo el mundo | http://www.nhc.noaa.gov/aboutnames.shtml | es     | active | cyclones.jpg    | ciclones       | NOAA              | http://www.noaa.gov   |
      | Cyclones (ciclones in Spanish)                  | http://www.nhc.noaa.gov/aboutnames.shtml | en     | active | cyclones.jpg    | cyclones       | NOAA              | http://www.noaa.gov   |
    When I go to the Spanish homepage
    And I fill in "query" with "ciclones"
    And I press "Buscar"
    Then I should see a link to "Nombres de ciclones tropicales en todo el mundo" with url for "http://www.nhc.noaa.gov/aboutnames.shtml" in the featured collections section
    And I should see "Nombres de ciclones tropicales en todo el mundo destacada por GobiernoUSA.gov" in the featured collections section
    And I should see an image with alt text "ciclones" in the featured collections section
    And I should see a link to "NOAA" with url for "http://www.noaa.gov" in the featured collections section
    And I should see "Imagen de NOAA" in the featured collections section
    And I should not see "Cyclones (ciclones in Spanish)"