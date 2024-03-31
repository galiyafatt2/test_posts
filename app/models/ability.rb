# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # гость

    if user.admin?
      can :manage, :all # Администраторы могут управлять всем
    else
      can :create, Post # Обычные пользователи могут создавать посты
      can :update, Post, user_id: user.id, status: "draft" # Обычные пользователи могут редактировать только свои черновики
      can :destroy, Post, user_id: user.id, status: "draft" # Обычные пользователи могут удалять только свои черновики
      can :submit_for_approval, Post, user_id: user.id, status: "draft" # Обычные пользователи могут отправить свои посты на проверку
    end
  end
end
