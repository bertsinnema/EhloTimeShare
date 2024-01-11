class Ability
  include CanCan::Ability

  def initialize(user)

    #Define public abillities
    can :read, Location, public: true
    can :read, Item, location: { public: true }
    return unless user.present?
    
    #allow anyone to create a new Location
    can :create, Location

    #Define Location specific abillities
    user.user_locations.each do |user_location|
      case user_location.role
        when 'owner'
          can :manage, Location, id: user_location.location_id
          can :manage, Item, location_id: user_location.location_id
          can :read, UserLocation, location_id: user_location.location_id
        
        when 'manager'
          can :read, Location, id: user_location.location_id
          can :manage, Item, location_id: user_location.location_id
          can :read, UserLocation, location_id: user_location.location_id
        
        when 'member'
          can :read, Location, id: user_location.location_id, public: false
          can :read, Item, location_id: user_location.location_id
          cannot :manage, UserLocation, location_id: user_location.location_id
          # Memebers can remove themselves from a location
          can :destroy, UserLocation, user_id: user.id, location_id: user_location.location_id
      end
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
