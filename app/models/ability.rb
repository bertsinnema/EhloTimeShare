# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    #Define public abillities
    can :read, Location, public: true
    can :read, Item, location: { public: true }
    return unless user.present?
    
    #allow anyone to create a Location
    #can :create, Location

    #Define Location specific abillities
    user.user_locations.each do |user_location|
      case user_location.role
      when 'owner'
        can :manage, Location, id: user_location.location_id
        can :manage, Item, location_id: user_location.location_id
        can :manage, UserLocation, location_id: user_location.location_id
        #Making sure only owners of a location can delete the location
        can :destroy, Location, id: user_location.location_id
      when 'manager'
        can :manage, Location, id: user_location.location_id
        can :manage, Item, location_id: user_location.location_id
        can :manage, UserLocation, location_id: user_location.location_id
      when 'member'
        can :read, Location, id: user_location.location_id, public: false
        can :read, Item, location_id: user_location.location_id
      end
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
