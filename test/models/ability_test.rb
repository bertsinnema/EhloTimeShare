# test/models/ability_test.rb
require 'test_helper'

# Tests the CanCanCan ACL configuration
class AbilityTest < ActiveSupport::TestCase
  
  # ANONYMOUS USERS
  test 'anonymous user can read public locations' do
    ability = Ability.new(nil)
    assert ability.can?(:read, locations(:shed))
  end

  test 'anonymous user cannot read private locations' do
    ability = Ability.new(nil)
    assert ability.cannot?(:read, locations(:hangar))
  end

  test 'anonymous user can read items of public locations' do
    ability = Ability.new(nil)
    assert ability.can?(:read, items(:hammer))
  end

  test 'anonymous user cannot read items of private locations' do
    ability = Ability.new(nil)
    assert ability.cannot?(:read, items(:cessna))
  end  


  # SIGNED IN USERS

  test 'you can manage a location when you are the owner' do
    ability = Ability.new(users(:orville))
    assert ability.can?(:manage, locations(:hangar))
  end

  test 'you cannot manage a location when you are not the owner' do
    ability = Ability.new(users(:orville))
    assert ability.cannot?(:manage, locations(:shed))
  end

  test 'you can manage items of a location where you are the owner' do
    ability = Ability.new(users(:orville))
    assert ability.can?(:manage, items(:cessna))
  end

  test 'you cannot manage items of a location where you are not the owner' do
    ability = Ability.new(users(:orville))
    assert ability.cannot?(:manage, items(:hammer))
  end  

  test 'you can manage users of a location where you are the owner' do
    ability = Ability.new(users(:orville))
    assert ability.can?(:manage, user_locations(:wilbur_manager_hangar))
    assert ability.can?(:manage, user_locations(:sully_member_hangar))
  end

  test 'you cannot manage users of a location where you are not the owner' do
    ability = Ability.new(users(:orville))
    assert ability.cannot?(:manage, user_locations(:bob_owner_shed))
  end  

  test 'you cannot manage yourself in a location you own' do
    ability = Ability.new(users(:orville))
    assert ability.cannot?(:manage, user_locations(:orville_owner_hangar))
  end  

  #todo: ownership transfer needs some thought, probably needs a custom ability



  test 'you cannot manage a location when you are the manager' do 
    ability = Ability.new(users(:wilbur))
    assert ability.cannot?(:manage, locations(:hangar))
  end

  test 'you can manage users of a location where you are the manager' do
    ability = Ability.new(users(:wilbur))
    assert ability.can?(:manage, user_locations(:sully_member_hangar))
  end

  test 'you can manage items of a location where you are the manager' do
    ability = Ability.new(users(:wilbur))
    assert ability.can?(:manage, items(:cessna))
  end

  test 'you cannot manage items of a location where you are not a member' do
    ability = Ability.new(users(:wilbur))
    assert ability.cannot?(:manage, items(:hammer))
  end 

  test 'you cannot manage an owner of a location where you are the manager' do 
    ability = Ability.new(users(:wilbur))
    assert ability.cannot?(:manage, user_locations(:orville_owner_hangar))    
  end

  test 'you cannot manage other managers of a location where you are a manager' do
    ability = Ability.new(users(:wilbur))
    assert ability.cannot?(:manage, user_locations(:bob_manager_hangar))
  end 

  test 'you cannot manage yourself in a location where you are a manager' do
    ability = Ability.new(users(:wilbur))
    assert ability.cannot?(:manage, user_locations(:wilbur_manager_hangar))
  end  
    
  test 'you cannot manage a location when you are a member' do
    ability = Ability.new(users(:sully))
    assert ability.cannot?(:manage, locations(:hangar))
  end

  test 'you cannot manage a location when you are not a member' do
    ability = Ability.new(users(:sully))
    assert ability.cannot?(:manage, locations(:shed))
  end  

  test 'you cannot manage items of a location where you are a member' do
    ability = Ability.new(users(:sully))
    assert ability.cannot?(:manage, items(:cessna))
  end

  test 'you cannot manage users of a location where you are a member' do
    ability = Ability.new(users(:sully))
    assert ability.cannot?(:manage, user_locations(:orville_owner_hangar))    
    assert ability.cannot?(:manage, user_locations(:wilbur_manager_hangar))    
    assert ability.cannot?(:manage, user_locations(:sully_member_hangar))  
  end

  test 'members can remove themselves from a location' do
    ability = Ability.new(users(:sully))
    assert ability.can?(:destroy, user_locations(:sully_member_hangar))
  end

end