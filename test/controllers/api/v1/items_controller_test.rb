# test/controllers/api/v1/items_controller_test.rb
require 'test_helper'

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest

    test 'should get items for unauthenticated user and public location' do
        get api_v1_location_items_url(locations(:shed))
        assert_response :success
        
        response_body = JSON.parse(response.body)
        public_location_items = items.select { |item| item['location_id'] == locations(:shed).id }
        
        assert_equal public_location_items.length, response_body['data'].length
    end

    test 'should not get items for unauthenticated user and private location' do
        get api_v1_location_items_url(locations(:hangar))
        assert_response :not_found
    end      

    test 'should not get get items for unauthenticated user and private location' do
        get api_v1_location_items_url(locations(:hangar))
        assert_response :not_found
    end   


end