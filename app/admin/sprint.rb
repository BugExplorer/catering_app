include ActiveAdminHelpers

ActiveAdmin.register Sprint do
  permit_params :title, :started_at, :closed_at, :state

  form do |f|
    f.inputs 'Daily Ration' do
      f.input :title
      f.input :started_at
      f.input :closed_at
      f.input :state, as: :select, collection: ['pending', 'running', 'closed']
    end
    f.actions
  end

  sidebar 'Done with ordering', only: :show do
    table_for User.ordered(sprint.id) do
      column 'User' do |user|
        link_to user.name, admin_user_path(user)
      end
    end
  end

  sidebar 'Not ordered yet', only: :show do
    table_for User.not_ordered(sprint.id) do
      column 'Name' do |user|
        link_to user.name, admin_user_path(user)
      end
    end
  end

  member_action :report do
      @report = fetch_report(params[:id])
      @report = generate_report(@report)

      respond_to do |format|
        format.any { render text: @report }
      end
  end

  action_item :view, only: :show do
    link_to 'Report', report_admin_sprint_path(format: :csv, sprint: sprint)
  end

end
