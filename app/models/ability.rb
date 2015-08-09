class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user.role == "Admin"
        can :manage, Home
        can :manage, Line #master LINE
        can :manage, User #master User/ pegawai
        can :manage, Board 
        can :manage, Problem

        #menu
        can :home, User
        can :visual_board, User
        can :visual_problem, User


    elsif user.role == "User"
        can :manage, Home
        can :manage, Line #master 
        can :manage, Report do |report|
            report.line.user.id == user.id
        end

        #menu


    end

  end
end
