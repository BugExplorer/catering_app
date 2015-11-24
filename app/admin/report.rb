ActiveAdmin.register_page "Sprint Report" do
  sprint = Sprint.running.last
  daily_rations = DailyRation.includes(:dish, :daily_menu)
    .where(sprint_id: sprint.id).to_a
  days = DailyMenu.all.to_a

  content do
    panel "#{sprint.title}" do
      table_for User.all do
        column('Name') { |u| u.name.capitalize }
        column('Sprint') { sprint.title }
        column('Daily Rations') do |u|
          ul do
            days.map do |day|
              current_day = daily_rations.select do |r|
                r.user_id == u.id && r.daily_menu_id == day.id
              end

              li "#{Date::DAYNAMES[day.day_number]} limit: #{day.max_total}"
              unless current_day.empty?
                ul do
                  current_day.map do |ration|
                    unless ration.dish.nil?
                      li "#{ration.dish.title} price: #{ration.price}"
                    end #unless
                  end # map
                end # ul
              end # unless
            end # days.map
          end # ul
        end # column
      end # table
    end # panel
  end # content
end