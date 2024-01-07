# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    #Define public abillities
    can :read, Location, public: true
    can :read, Item, location: { public: true }
    return unless user.present?
    
    #Define role specific abillities
    user.user_locations.each do |user_location|
      case user_location.role
      when 'owner'
        can :manage, Location, id: user_location.location_id
        can :manage, Item, location_id: user_location.location_id
        can :manage, UserLocation, location_id: user_location.location_id
      when 'manager'
        can :manage, Location, id: user_location.location_id
        can :manage, Item, location_id: user_location.location_id
        can :manage, UserLocation, location_id: user_location.location_id
      when 'member'
        can :read, Location, id: user_location.location_id, public: false
        can :read, Item, location_id: user_location.location_id
      end
    end

    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
