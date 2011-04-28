class Portfolio < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name        :string
    description :text
    value       :float
    hexcolor    :string
    timestamps
  end

  has_many :stockposts, :dependent => :destroy
  
  #never_show :value
=begin  
  before_save :set_updated

  def set_updated
    self.updated_at = DateTime.now()
    self.save
  end
=end
 
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

  def view_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    acting_user.administrator?
  end
  
  def value_edit_permitted?
    false
  end
  
  def updateVals
    logger.info "update portfolio"
    
    portfolioTotVal = 0
    
    #kolla om stockposts curr value måste uppdateras
    self.stockposts.each do |sp|
      seconds = ((sp.updated_at.to_time) - DateTime.now.to_time)
      
      logger.info sp.updated_at.to_time
      logger.info DateTime.now.to_time
      logger.info seconds

      if seconds < -1800
        logger.info "should update"
        quotes = YahooFinance::get_standard_quotes(sp.name) 
         quotes.each do |symbol, qt|
           get = qt.get_info
           val = get.each(':').collect[1].strip.sub(':','')
           #sp.value = val
           #sp.save
           sp.value = val
           sp.save!
         end
      end 
      
      portfolioTotVal += sp.value*sp.amount
      
    end
  
    logger.info portfolioTotVal
    
    return portfolioTotVal
    
  end
  
  def getRelWeights
    rh = Hash.new()
    
    logger.info "getRelWeights"
    self.stockposts.each do |sp|
      r = (sp.value*sp.amount)/self.value
      #logger.info sp.name
      #logger.info r*100
      rh[sp.name] = r*100
    end
    
    logger.info "updated!"
    return rh
  end
  
  def getHistory
    
    logger.info "getHistory"
    
    allStocksHistory = Array.new()
    
    seconds = self.updated_at.to_time - DateTime.now.to_time
    
    forceUpdate = true
    
    if seconds < -3600 || forceUpdate #do port update
      
      stocksSortedByAcquired = self.stockposts.sort_by { |sp| sp.acquired }
      
      logger.info "update port"
      
      stocksSortedByAcquired.each do |sp|
        acquiredPrice = nil
        sp.updateHistory
        sdlist = sp.stockdatas.sort_by { |sd| sd.d }
        
        stockHistory = Array.new()
        
        sdlist.each do |sd|
          acquiredPrice = sd.value if acquiredPrice.nil?
          data = Array.new()
          data.push(sd.value*sp.amount)
          logger.info sd.d.to_s
          logger.info sd.value
          logger.info acquiredPrice
          data.push(acquiredPrice*sp.amount)
          stockHistory.push(data)
          
        end #end data
        
        allStocksHistory.push(stockHistory)
        
      end #end stockSorted
      
    end #do port update

    return allStocksHistory
    
  end
  

  
end
