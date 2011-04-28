class Stockdata < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    d     :date
    value :float
    timestamps
  end

  belongs_to :stockpost
  
  
  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
