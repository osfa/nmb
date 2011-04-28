class Stockpost < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name     :string
    acquired :date
    amount   :integer
    value    :float
    timestamps
  end


  belongs_to :portfolio
  validates_numericality_of :amount, :only_integer => true, :message => "can only be whole number."
  validate :name
  
  has_many :stockdatas, :dependent => :destroy #DÖDAR INTE?!

  def updateHistory
    logger.info "updateHistory"
    
      if self.stockdatas.length > 0
        if self.acquired > self.stockdatas.last.d
          logger.info "clean"
          self.stockdatas.destroy_all
        end
      end
    
   
    #self.stockdatas.destroy_all
    
    if self.stockdatas.length < 1 # || timeout
      logger.info "need base update"
      history = YahooFinance::get_historical_quotes( self.name, self.acquired, Date.today())
      history.each do |h|
        tmp = Stockdata.new(:d => h[0], :value => h[4])
        if !self.stockdatas.include?(tmp)
          self.stockdatas.push(tmp)
          logger.info "NEW FIELD"
        end
      end
    end    

  end
  
  def validate
     logger.info "validate!!!"
    
     quotes = YahooFinance::get_standard_quotes( name )
     quotes.each do |symbol, qt|
       get = qt.get_info
       val = get.each(':').collect[1].strip.sub(':','')
       
       if Float(val) == 0.0
         errors.add(:name, "doesn't exist.") 
       end
      
     end
     
  end
  
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
    acting_user.administrator?
  end
  
  def value_edit_permitted?
    false
  end

end
