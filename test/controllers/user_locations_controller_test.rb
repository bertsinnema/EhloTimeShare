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
end