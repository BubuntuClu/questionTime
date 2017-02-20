class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with current_resource_owner
  end

  def other_users
    respond_with (User.other_users(current_resource_owner.id))
  end
end
