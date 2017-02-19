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
    can :create, [Question, Answer, Comment]
    can :create, Vote do |vote|
      @user.author_of?(vote.votable)
    end
    can :update, [Question, Answer], user_id: @user.id
    can :destroy, [Question, Answer, Vote], user_id: @user.id

    can :manage, Attachment, attachmentable: { user_id: @user.id }
    can :mark_best, Answer do |answer|
      @user.author_of?(answer.question) && !answer.best
    end
  end
end
