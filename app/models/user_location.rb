class UserLocation < ApplicationRecord
  enum role: { owner: 'owner', manager: 'manager', member: 'member' }

  belongs_to :user
  belongs_to :location
end
