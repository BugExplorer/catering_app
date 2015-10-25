require "grape"

module API
  module Version1
    class DailyMenus < ::Grape::API
      version 'v1', using: :path

      resource :dailu_menus do
        desc "Returns sprints that are running or being closed"
        get "/" do
          DailyMenu.all
        end

        # desc "Return post info"
        # get "/:id" do
        #   @post = Post.find(params[:id])
        #   @post
        # end
      end
    end
  end
end
