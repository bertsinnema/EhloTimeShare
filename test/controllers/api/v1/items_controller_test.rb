# test/controllers/api/v1/items_controller_test.rb
require 'test_helper'

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest

    
    # GET /api/v1/locations/:location_id/items
    
    test 'should only get active items for unauthenticated user and public location' do
        get api_v1_location_items_url(locations(:shed))
        assert_response :success
        
        response_body = JSON.parse(response.body)
        public_location_items = items.select { |item| item['location_id'] == locations(:shed).id && item['active'] == true }
        
        assert_equal public_location_items.length, response_body['data'].length
    end

    test 'should only get active items for member of private location' do
        get api_v1_location_items_url(locations(:hangar)), headers: get_auth_headers(users(:sully))
        assert_response :success
        
        response_body = JSON.parse(response.body)
        public_location_items = items.select { |item| item['location_id'] == locations(:shed).id && item['active'] == true }
        
        assert_equal public_location_items.length, response_body['data'].length
    end    

    test 'should get active and inactive items for owner of a location' do
        get api_v1_location_items_url(locations(:hangar)), headers: get_auth_headers(users(:orville))
        assert_response :success        
        
        response_body = JSON.parse(response.body)
        
        # Includes inactive items
        public_location_items = items.select { |item| item['location_id'] == locations(:shed).id}
        
        assert_equal public_location_items.length, response_body['data'].length
    end 
    
    test 'should get active and inactive items for manager of a location' do
        get api_v1_location_items_url(locations(:shed)), headers: get_auth_headers(users(:alice))
        assert_response :success        
        
        response_body = JSON.parse(response.body)
        
        # Includes inactive items
        public_location_items = items.select { |item| item['location_id'] == locations(:shed).id}
        
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


    # POST /api/v1/locations/:location_id/items
    test 'should be able to create an item as the owner of a location' do
        assert_difference('Item.count', 1) do
            post api_v1_location_items_url(locations(:hangar)),
                params: {
                    data: {
                        type: 'item',
                        attributes: {
                            name: 'Blimp',
                            description: 'It is a Goodyear to fly in a blimp',
                            active: true
                        },
                        relationships: {
                            location: {
                                data: {
                                    type: "location",
                                    id: locations(:hangar).id
                                }
                            }
                        }         
                    }
                },
            headers: get_auth_headers(users(:orville)),
            as: :json
        end
        assert_response :created
    end

    test 'should be able to create an item as the manager of a location' do
        assert_difference('Item.count', 1) do
            post api_v1_location_items_url(locations(:shed)),
                params: {
                    data: {
                        type: 'item',
                        attributes: {
                            name: 'Blimp',
                            description: 'It is a Goodyear to fly in a blimp',
                            active: true
                        },
                        relationships: {
                            location: {
                                data: {
                                    type: "location",
                                    id: locations(:shed).id
                                }
                            }
                        }         
                    }
                },
            headers: get_auth_headers(users(:alice)),
            as: :json
        end
        assert_response :created
    end 
    
    test 'should not be able to create an item a a member of a location' do
        assert_no_difference('Item.count') do
            post api_v1_location_items_url(locations(:hangar)),
                params: {
                    data: {
                        type: 'item',
                        attributes: {
                            name: 'Blimp',
                            description: 'It is a Goodyear to fly in a blimp',
                            active: true
                        },
                        relationships: {
                            location: {
                                data: {
                                    type: "location",
                                    id: locations(:hangar).id
                                }
                            }
                        }         
                    }
                },
            headers: get_auth_headers(users(:sully)),
            as: :json
        end
        assert_response :not_found
    end
    # PUT /api/v1/locations/:location_id/items/:id
    
    test 'should be able to update item when user is the owner' do     
        item = items(:hammer)
        put api_v1_location_item_url(locations(:shed), item),
              params: {
                data: {
                  type: 'item',
                  id: item.id,
                  attributes: {
                    name: 'Hummer',
                    description: 'Now it is a car you dont want to be seen in',
                    active: false
                  }
                }
              },
              headers: get_auth_headers(users(:bob)),
              as: :json
      
        assert_response :ok
      
        # Reload the record from the database to get the updated attributes
        item.reload
      
        # Assert that the attributes have been updated
        assert_equal 'Hummer', item.name
        assert_equal 'Now it is a car you dont want to be seen in', item.description
        assert_equal false, item.active
    end

    test 'should be able to update item when user is the manager' do     
        item = items(:hammer)
        put api_v1_location_item_url(locations(:shed), item),
              params: {
                data: {
                  type: 'item',
                  id: item.id,
                  attributes: {
                    name: 'Hummer',
                    description: 'Now it is a car you dont want to be seen in',
                    active: false
                  }
                }
              },
              headers: get_auth_headers(users(:alice)),
              as: :json
      
        assert_response :ok
      
        # Reload the record from the database to get the updated attributes
        item.reload
      
        # Assert that the attributes have been updated
        assert_equal 'Hummer', item.name
        assert_equal 'Now it is a car you dont want to be seen in', item.description
        assert_equal false, item.active
    end 
    
    test 'should not be able to item location when user is unauthenticated' do     
        item = items(:hammer)
        put api_v1_location_item_url(locations(:shed), item),
              params: {
                data: {
                  type: 'item',
                  id: item.id,
                  attributes: {
                    name: 'Hummer',
                    description: 'Now it is a car you dont want to be seen in',
                    active: false
                  }
                }
              },
              as: :json
      
        assert_response :not_found
    end 
    
    test 'should not be able to item location when user is member' do     
        item = items(:piper)
        put api_v1_location_item_url(locations(:hangar), item),
              params: {
                data: {
                  type: 'item',
                  id: item.id,
                  attributes: {
                    name: 'Hummer',
                    description: 'Now it is a car you dont want to be seen in',
                    active: false
                  }
                }
              },
              headers: get_auth_headers(users(:sully)),
              as: :json
      
        assert_response :not_found
    end 
    
    test 'should not be able to item location when user is in other location' do     
        item = items(:hammer)
        put api_v1_location_item_url(locations(:shed), item),
              params: {
                data: {
                  type: 'item',
                  id: item.id,
                  attributes: {
                    name: 'Hummer',
                    description: 'Now it is a car you dont want to be seen in',
                    active: false
                  }
                }
              },
              headers: get_auth_headers(users(:orville)),
              as: :json
      
        assert_response :not_found
    end     
    
    # DELETE /api/v1/locations/:location_id/items/:id
    test 'should not be able to delete an item as non authenticated' do
        assert_no_difference('Item.count') do
            delete api_v1_location_item_url(locations(:hangar), items(:piper))
        end
        assert_response :not_found
    end

    test 'should not be able to delete an item as a member of a location' do
        assert_no_difference('Item.count') do
            delete api_v1_location_item_url(locations(:hangar), items(:piper)),
            headers: get_auth_headers(users(:sully))
        end
        assert_response :not_found
    end 

    test 'should not be able to delete an item of a location you are not an owner in' do
        assert_no_difference('Item.count') do
            delete api_v1_location_item_url(locations(:shed), items(:hammer)),
            headers: get_auth_headers(users(:orville))
        end
        assert_response :not_found
    end     
    
    test 'should be able to delete an item as an owner of a location' do
        assert_difference('Item.count', -1) do
            delete api_v1_location_item_url(locations(:hangar), items(:piper)),
            headers: get_auth_headers(users(:orville))
        end
        assert_response :no_content
    end 
    
    test 'should be able to delete an item as a manager of a location' do
        assert_difference('Item.count', -1) do
            delete api_v1_location_item_url(locations(:hangar), items(:piper)),
            headers: get_auth_headers(users(:wilbur))
        end
        assert_response :no_content
    end     
end