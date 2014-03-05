class ContestsController < ApplicationController
	before_action :current_user!

	def index
	end

	def new
		@contest = Contest.new
	end

	def create
		require_params params, false, :contest
		require_params params[:contest], false, :name, :round

		@contest = Contest.create name: params[:contest][:name],
			round: params[:contest][:round].to_i, status: 0, owner_id: @user._id,
			description: params[:contest][:description]

		redirect_to @contest
	end

	def join
		require_contest false, 0

		@contest.competitors.push Competitor.new(score: 0, user_id: @user._id)
		@contest.save
		redirect_to @contest
	end

	def show
		require_contest
	end

	def open
		require_contest true, 0

		raise ClientException.new 'Competitor size must be even!' unless @contest.competitors.size % 2 == 0
		@contest.status = 1
		@contest.save
		redirect_to @contest
	end

	def test
		require_contest true, 1

		@contest.next_round
		redirect_to contests_path
	end

	def destroy
		require_contest
		@contest.destroy
		redirect_to contests_path
	end

	private

	def require_contest(admin = false, status = nil)
		require_params params, false, :id
		@contest = Contest.find params[:id]
		raise ClientException.new 'Contest not found!'if @contest.nil?
		raise ClientException.new 'You have no permission!' if admin && !@contest.admin?(@user)
		unless status.nil? || status == @contest.status
			raise ClientException.new "Contest status required: #{Contest::STATUS_MSG[status]}"
		end
	end
end
