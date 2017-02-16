class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote]
    can :update, [Question, Answer], user: @user
    can :destroy, [Question, Answer, Vote], user: @user

    can :destroy, Comment do |comment|
      comment.users_id == @user.id
    end
    can :manage, Attachment do |attachment|
      attachment.attachmentable.user_id == @user.id
    end
    can :mark_best, Question, user: @user
  end
end
