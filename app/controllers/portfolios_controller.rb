class PortfoliosController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  #insert if changed here or something
  def show
    
    @portfolio = find_instance
    totVal = @portfolio.updateVals #important
    
    @portfolio.update_attribute(:value, totVal)# = totVal
    #@portfolio.save
    
    #rh = @portfolio.getRelWeights #returns rel weight
    
    #@charturl = generatePieChart(rh)
    #logger.info @charturl
    
    hobo_show
    
  end

  def piechart
    
    @portfolio = find_instance

    totVal = @portfolio.updateVals #important
    
    @portfolio.value
    @portfolio.save
    
    rh = @portfolio.getRelWeights #returns rel weight
    
    @charturl = generatePieChart(rh, @portfolio.hexcolor)
    logger.info @charturl
    
  end
  
  def generatePieChart(relWeightHash, color)
    
    cvals = Array.new
    clabs = Array.new
    
    relWeightHash.each do |name,percent|
      logger.info name
      logger.info percent
      cvals.push(percent.round(2))
      clabs.push(name + " " + String(percent.round(2)) + "%")
    end
    
    #clabs = clabs.chop
    #cvals = cvals.chop

    #chartUrl = "http://chart.apis.google.com/chart?chxs=0,676767,14.167&chxt=x&chs=600x200&cht=p3&chco="+color+"&chd=t:"+cvals+"&chp=0.067&chl="+clabs+"&chma=|11"
    #return chartUrl
    
    
    chart = Gchart.pie_3d(:size => '600x200', :data => cvals, :labels => clabs, :custom => "&chco="+color)
    return chart
  end

end