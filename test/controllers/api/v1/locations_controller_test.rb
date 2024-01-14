# test/controllers/api/v1/locations_controller_test.rb
require 'test_helper'

class Api::V1::LocationsControllerTest < ActionDispatch::IntegrationTest
    # ANONYMOUS USER
    test 'should get index for unauthenticated user and only see public listings' do
        get api_v1_locations_url
        assert_response :success

        response_body = JSON.parse(response.body)
        public_locations = locations.select { |loc| loc['public'] }

        assert_equal public_locations.length, response_body['data'].length
    end

    test 'should show public location for unauthenticated user' do
        get api_v1_location_url(locations(:shed))
        assert_response :success
    end

    test 'should not show private location for unauthenticated user' do
        get api_v1_location_url(locations(:hangar))
        assert_response :not_found
    end

    test 'should get items for unauthenticated user and public location' do
        get items_api_v1_location_url(locations(:shed))
        assert_response :success
        
        response_body = JSON.parse(response.body)
        public_location_items = items.select { |item| item['location_id'] == locations(:shed).id }
        
        assert_equal public_location_items.length, response_body['data'].length
    end

    test 'should not get items for unauthenticated user and private location' do
        get items_api_v1_location_url(locations(:hangar))
        assert_response :not_found
    end      

    test 'should not get get items for unauthenticated user and private location' do
        get items_api_v1_location_url(locations(:hangar))
        assert_response :not_found
    end   

    test 'should be able to create location when logged in and is geocoded' do
        assert_difference('Location.count') do
        post api_v1_locations_url,
            params: {
                data: {
                    type: 'location',
                    attributes: {
                        name: 'Boomtown',
                        city: 'Eelde',
                        street: 'sdsdsd',
                        zipcode: '2323',
                        country: 'The Netherlands',
                        public: true
                    }
                }
            },
            headers: get_auth_headers(users(:alice)),
            as: :json  # Set the request format to JSON
        end
        assert_response :created
    end

    test 'should not be able to create a location when logged out' do
        assert_no_difference('Location.count') do
        post api_v1_locations_url,
            params: {
                data: {
                    type: 'location',
                    attributes: {
                        name: 'Boomtown',
                        city: 'Eelde',
                        street: 'sdsdsd',
                        zipcode: '2323',
                        country: 'The Netherlands',
                        public: true
                    }
                }
            },
            as: :json  # Set the request format to JSON
        end
        assert_response :not_found
    end    

    test 'should be able to update location when user is the owner' do
        # Assume 'location' is an existing record in your test database
        location = locations(:shed)
      
        put api_v1_location_url(location),
              params: {
                data: {
                  type: 'location',
                  id: location.id,
                  attributes: {
                    name: 'Updated Location',
                    street: '1 Microsoft Way',
                    city: 'Redmond',
                    zipcode: 'WA 98052',
                    country: 'United States',
                    public: false
                  }
                }
              },
              headers: get_auth_headers(users(:bob)),
              as: :json
      
        assert_response :ok
      
        # Reload the record from the database to get the updated attributes
        location.reload
      
        # Assert that the attributes have been updated
        assert_equal 'Updated Location', location.name
        assert_equal '1 Microsoft Way', location.street
        assert_equal 'Redmond', location.city
        assert_equal 'WA 98052', location.zipcode
        assert_equal 'United States', location.country
        assert_equal false, location.public
    end

    test 'should not be able to update location when user is not the owner' do
        put api_v1_location_url(locations(:shed)),headers: get_auth_headers(users(:orville))
        assert_response :not_found
        
        put api_v1_location_url(locations(:hangar)),headers: get_auth_headers(users(:alice))
        assert_response :not_found
        
        put api_v1_location_url(locations(:hangar)),headers: get_auth_headers(users(:sully))
        assert_response :not_found
        
        put api_v1_location_url(locations(:hangar)),headers: get_auth_headers(users(:wilbur))
        assert_response :not_found
    end


    test 'should not be able to destroy a location if the user doesnt own it' do
        delete api_v1_location_url(locations(:hangar)), headers: get_auth_headers(users(:alice))
        assert_response :not_found

        delete api_v1_location_url(locations(:hangar)), headers: get_auth_headers(users(:bob))
        assert_response :not_found

        delete api_v1_location_url(locations(:hangar)), headers: get_auth_headers(users(:wilbur))
        assert_response :not_found                
    end

    test 'should be able to destroy a location if you own it' do
        delete api_v1_location_url(locations(:hangar)), headers: get_auth_headers(users(:orville))
        assert_response :no_content
    end    
end