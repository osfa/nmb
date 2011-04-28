class StockpostsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :portfolio, [:new, :create]
  
  def show
    logger.info "show!!!"
    @stock = find_instance
    logger.info @stock.name
    val = 0.0
    quotes = YahooFinance::get_standard_quotes(@stock.name ) #test here
    quotes.each do |symbol, qt|
      get = qt.get_info
      val = get.each(':').collect[1].strip.sub(':','')
      logger.info val
    end
    
    #logger.info @stock.updated_at
    @stock.update_attribute(:value, val)
    #logger.info @stock.updated_at
    
    #@stock.value = val
    #@stock.save!
    
    hobo_show

  end
end


