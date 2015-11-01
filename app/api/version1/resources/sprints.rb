require "grape"

module API
  module Version1
    class Sprints < ::Grape::API
      version 'v1', using: :path

      resource :sprints do
        desc "Returns sprints that are running or being closed", headers: {
          "X-Auth-Token" => {
            description: "User token",
            required: true
          }
        }

        get "/" do
          Sprint.all
          # Sprint.where(status: ["running", "closed"])
        end

        desc "Returns daily rations for sprint"
        get "/:id" do
          # if Sprint.find(params[:id]).running? || Sprint.find(params[:id]).closed?
          DailyRation.where(sprint_id: params[:id])
          # else
          #   error!({:errors => "This sprint is pending"}, 422)
          # end
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
