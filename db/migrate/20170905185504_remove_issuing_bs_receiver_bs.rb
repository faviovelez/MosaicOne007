class RemoveIssuingBsReceiverBs < ActiveRecord::Migration
  def change
    drop_table :issuing_bs_receiver_bs
  end
end
