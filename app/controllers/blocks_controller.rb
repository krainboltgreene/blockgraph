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
    BlockTrunkWorker.perform_async(@block.id, params[:username].gsub("@", ""))

    redirect_to blocks_path
  end
end
