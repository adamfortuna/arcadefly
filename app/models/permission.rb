# This controls user permissions by associating a role with a user.
class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end