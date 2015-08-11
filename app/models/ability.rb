class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user.role == "Admin"
        can :manage, Home
        can :manage, Line #master LINE
        can :manage, User #master User/ pegawai
        can :manage, Board 
        can :manage, Problem
        can :data, Report do |report|
            report.line.user.role == "Admin"
        end

        #menu
        can :home, User
        can :visual_board, User
        can :visual_problem, User
        can :line, User


    elsif user.role == "User"
        can :manage, Home
        can :manage, Line #master 

        can :manage, Report do |report|
            if report.line != nil
                report.line.user.id == user.id
            else
                :all
            end
        end

        can :manage, Detailreport do |detailreport|
            detailreport.line.user.id == user.id
        end

        #menu
        can :update, User, :id => user.id

    end
  end
end
