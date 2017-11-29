class TicketsController < ApplicationController

  def index
    store = current_user.store
    @tickets = store.tickets.where(parent:nil).where(bill: nil)
  end




end
