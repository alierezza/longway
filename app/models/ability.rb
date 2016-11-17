class Ability
  include CanCan::Ability

  def initialize(user)

    if user.role == "Admin"

        if user.email == "visualboard@longway.vn" || user.email == "visualboard@globalwayindonesia.com"
            #menu
            can :home, User
            can :visual_board, User

            can :manage, Home
            can :manage, Board
            can :read, Ad


        elsif user.email == "machineproblem@longway.vn" || user.email == "machineproblem@globalwayindonesia.com"
            #menu
            can :home, User
            can :visual_problem, User

            can :manage, Home
            can :manage, Problem
        elsif user.email == "admin@longway.vn" || user.email == "admin@globalwayindonesia.com" #admin

            #menu
            can :home, User
            can :visual_board, User
            can :visual_problem, User
            can :line, User
            can :masteremail, User
            can :running_text, User
            can :image, User
            can :country, User
            can :category, User

            can :manage, Home
            can :manage, Line #master LINE
            can :manage, User #master User/ pegawai
            can :manage, Board
            can :manage, Problem
            can :manage, Masteremail
            can [:data,:data_update], Report do |report|
                report.line.user.role == "Admin"
            end
            can :manage, Ad
            can :manage, Image
            can :manage, Article
            can :manage, Country
            can :manage, Category
            can :manage, Defect
            can :manage, HeaderBoard
            can :manage, WorkingDay
            can :manage, WorkingHour
            can :manage, Language
            can :manage, Setting
            can :manage, Emailsetting
        end


    elsif user.role == "User"
        can :manage, Home

        #can :manage, Line #master

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
