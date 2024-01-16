# test/controllers/api/v1/user_locations_controller_test.rb
require 'test_helper'

class Api::V1::UserLocationsControllerTest < ActionDispatch::IntegrationTest

    test 'should get users if you are an owner or manager of a location, and not when a member or non member' do
        get api_v1_location_users_url(locations(:hangar)), headers: get_auth_headers(users(:orville))
        assert_response :success

        get api_v1_location_users_url(locations(:hangar)), headers: get_auth_headers(users(:wilbur))
        assert_response :success

        get api_v1_location_users_url(locations(:hangar)), headers: get_auth_headers(users(:bob))
        assert_response :success           
        
        get api_v1_location_users_url(locations(:shed)), headers: get_auth_headers(users(:bob))
        assert_response :success    
        
        get api_v1_location_users_url(locations(:hangar)), headers: get_auth_headers(users(:alice))
        assert_response :not_found   
        
        get api_v1_location_users_url(locations(:hangar)), headers: get_auth_headers(users(:sully))
        assert_response :not_found           
    end

    test 'should not get users for unauthenticated user for public and private location' do
        get api_v1_location_users_url(locations(:shed))
        assert_response :not_found
        get api_v1_location_users_url(locations(:hangar))
        assert_response :not_found
    end


    test 'Should not be able to remove yourself as an owner' do
        assert_no_difference('UserLocation.count') do
            delete api_v1_location_user_url(locations(:hangar),users(:orville)), headers: get_auth_headers(users(:orville))
        end
        
        assert_response :not_found 
    end

    test 'Should be able to remove yourself as a manager or member' do
        assert_difference('UserLocation.count', -1) do
            delete api_v1_location_user_url(locations(:hangar),users(:sully)), headers: get_auth_headers(users(:sully))
        end
        assert_response :no_content 

        assert_difference('UserLocation.count', -1) do
            delete api_v1_location_user_url(locations(:hangar),users(:wilbur)), headers: get_auth_headers(users(:wilbur))
        end        
        assert_response :no_content 
    end

    test 'Should be able to remove a member as an owner and manager' do
        assert_difference('UserLocation.count', -1) do
            delete api_v1_location_user_url(locations(:hangar),users(:sully)), headers: get_auth_headers(users(:wilbur))
        end        
        assert_response :no_content 

        assert_difference('UserLocation.count', -1) do
            delete api_v1_location_user_url(locations(:hangar),users(:wilbur)), headers: get_auth_headers(users(:orville))
        end        
        assert_response :no_content         
    end

    test 'Should not be able to remove others as a member' do
        assert_no_difference('UserLocation.count') do
            delete api_v1_location_user_url(locations(:hangar),users(:orville)), headers: get_auth_headers(users(:sully))
        end        
        assert_response :not_found 

        assert_no_difference('UserLocation.count') do
            delete api_v1_location_user_url(locations(:hangar),users(:wilbur)), headers: get_auth_headers(users(:sully))
        end        
        assert_response :not_found         
    end

    test 'managers should not be able to remove other managers' do
        assert_no_difference('UserLocation.count') do
            delete api_v1_location_user_url(locations(:hangar),users(:wilbur)), headers: get_auth_headers(users(:bob))
        end        
        assert_response :not_found 
        assert_no_difference('UserLocation.count') do
            delete api_v1_location_user_url(locations(:hangar),users(:bob)), headers: get_auth_headers(users(:wilbur))
        end        
        assert_response :not_found           
    end

    test 'managers should not be able to remove other managers in other locations' do
        assert_no_difference('UserLocation.count') do
            delete api_v1_location_user_url(locations(:hangar),users(:wilbur)), headers: get_auth_headers(users(:alice))
        end        
        assert_response :not_found 
    end

    test 'should be able to update user_location when user is the owner' do
        # Assume 'location' is an existing record in your test database
        user_location = user_locations(:wilbur_manager_hangar)
        location = locations(:hangar)
      
        put api_v1_location_user_url(location,user_location),
              params: {
                data: {
                  type: 'user_location',
                  id: user_location.id,
                  attributes: {
                    location_id: user_location.location_id,
                    role: 'member'
                  }
                }
              },
              headers: get_auth_headers(users(:orville)),
              as: :json
      
        assert_response :ok
      
        # Reload the record from the database to get the updated attributes
        user_location.reload
      
        # Assert that the attributes have been updated
        assert_equal 'member', user_location.role
    end

    test 'should not be able to update user_location when user is not an owner' do
        # Assume 'location' is an existing record in your test database
        user_location = user_locations(:wilbur_manager_hangar)
        location = locations(:hangar)
      
        put api_v1_location_user_url(location,user_location),
              params: {
                data: {
                  type: 'user_location',
                  id: user_location.id,
                  attributes: {
                    location_id: user_location.location_id,
                    role: 'member'
                  }
                }
              },
              headers: get_auth_headers(users(:sully)),
              as: :json
      
        assert_response :not_found

        put api_v1_location_user_url(location,user_location),
              params: {
                data: {
                  type: 'user_location',
                  id: user_location.id,
                  attributes: {
                    location_id: user_location.location_id,
                    role: 'member'
                  }
                }
              },
              headers: get_auth_headers(users(:bob)),
              as: :json
      
        assert_response :not_found        
    end  
    
    test 'should not be able to update user_location when user is owner outside the current location' do
        # Assume 'location' is an existing record in your test database
        user_location = user_locations(:bob_owner_shed)
        location = locations(:shed)
      
        put api_v1_location_user_url(location,user_location),
              params: {
                data: {
                  type: 'user_location',
                  id: user_location.id,
                  attributes: {
                    location_id: user_location.location_id,
                    role: 'member'
                  }
                }
              },
              headers: get_auth_headers(users(:orville)),
              as: :json
      
        assert_response :not_found
    end

    test 'should not be able to update user_location on yourself as owner' do
        # Not able to as we implement an ownership transfer strategy for this
        user_location = user_locations(:orville_owner_hangar)
        location = locations(:hangar)
      
        put api_v1_location_user_url(location,user_location),
              params: {
                data: {
                  type: 'user_location',
                  id: user_location.id,
                  attributes: {
                    location_id: user_location.location_id,
                    role: 'member'
                  }
                }
              },
              headers: get_auth_headers(users(:orville)),
              as: :json
      
        assert_response :not_found
    end

end