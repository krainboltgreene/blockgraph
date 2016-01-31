class BlocksController < ApplicationController
  before_action :authenticate_account!

  def index
    @blocks = current_account.blocks
  end

  def show
    @block = current_account.blocks.find_by!(id: params[:id])
  end

  def new
    @block = Block.new
  end

  def create
    @block = current_account.blocks.create!
    username = params[:username].gsub("@", "")

    InitiateGraphWorker.perform_async(current_account.id, @block.id, username)

    redirect_to blocks_path
  end
end
