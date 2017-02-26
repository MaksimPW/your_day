class RatingPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user && user.author_of?(record)
  end

  def create?
    user
  end

  def update?
    show?
  end
end