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
			round: params[:contest][:round].to_i, status: 0, owner_id: @user._id
		redirect_to @contest
	end

	def join
		require_params params, false, :id
		@contest = Contest.find params[:id]
		raise ClientException.new 'Contest not found!' if @contest.nil?
		raise ClientException.new 'Contest has already started!' unless @contest.status == 0
		raise ClientException.new 'Already joint!' if @contest.joint? @user
		@contest.competitors.push Competitor.new(score: 0, user_id: @user._id)
		@contest.save
		redirect_to @contest
	end

	def show
		@contest = Contest.find params[:id]
		raise ClientException.new 'Contest not found!' if @contest.nil?
	end

	def open
		require_params params, false, :id
		@contest = Contest.find params[:id]
		raise ClientException.new 'Contest not found!' if @contest.nil?
		raise ClientException.new 'You have no permission!' unless @contest.admin? @user
		raise ClientException.new 'Contest has already started!' if @contest.status > 0
		raise ClientException.new 'Competitor size must be even!' unless @contest.competitors.size % 2 == 0
		@contest.status = 1
		@contest.save
		redirect_to @contest
	end

	def test
		require_params params, false, :id
		@contest = Contest.find params[:id]
		raise ClientException.new 'Contest not found!' if @contest.nil?
		raise ClientException.new 'You have no permission!' unless @contest.admin? @user
		raise ClientException.new 'Contest has not started!' unless @contest.status > 0
		@contest.next_round
		redirect_to contests_path
	end
end
