class FrontController < ApplicationController

  hobo_controller

  def index
    @portfolios = Portfolio.find(:all)
=begin
    @portfolios.each do |portfolio|
      logger.info "GO!"
       portfolio.getHistory
    end
=end
  
    #stocksSortedByAcquired = self.stockposts.sort_by { |sp| sp.acquired }
    firstdata = DateTime.now().to_date
    
    lineData = Array.new()
    legendData = Array.new()
    colorData = ""
    shortest = 1000
    @portfolios.each do |portfolio|
       
       ld = generateLineData(portfolio.getHistory)
       #portfolio.update 
       if ld.length < shortest
         shortest= ld.length
       end
       
       lineData.push(ld)
       legendData.push(portfolio.name)
       colorData += portfolio.hexcolor + ","
    end
    s = lineData.sort { |a,b| a.length <=> b.length }
        
    colorData = colorData.chop
    
    logger.info colorData
    logger.info shortest
    lineData.each do |da|
        da = da.drop(da.length - shortest)
    end
    
    logger.info lineData[0].drop(70).length
    logger.info lineData[1].length
    
    #chxr=1,-7.947,2.091
    #chds=-7.947,2.091
    #lineData[0].max
    
    @chart = Gchart.line(:data => lineData,
                            :line_colors => colorData,
                            :size => '600x450',
                            #:legend => legendData,
                            :axis_with_labels => 'x,y',
                            :axis_labels => [ firstdata.to_s+'|Idag'],
                            :custom => '&chdls=676767,20&chma=30,30,30,30'
                        )

   #hobo_index
    
  end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end
  
  def generateLineData(valArray)
    gain = Array.new()#valArray[0].length)
    baseVal = Array.new()
    
    i = 0
    valArray.each do |stockHistory|
      insertoffset = valArray[0].length - valArray[i].length
      j = 0
      stockHistory.each do |data|
        
          valueNow = data[0]
          acquiredAt = data[1]
          idx = j+insertoffset
          
          oldval = 0.0
          unless gain[idx].nil?
            oldval = gain[idx]
          end
          
          gain[idx] = (oldval+valueNow).round(2)
          
          unless baseVal[idx].nil?
             oldval = baseVal[idx]
          end    
           
          baseVal[idx] = (oldval+acquiredAt).round(2)
          
          j += 1
      end
      i+= 1
    end
    
    #logger.info gain.length
    #logger.info baseVal.length
    
    res = Array.new()
    i = 0
    
    #evens = Array.new(gain.size / 2){|i| i * 2} 
    #ods = Array.new(gain.size / 2){|i| i * 2 + 1}
    #gain.replace gain.values_at(*evens) 
    logger.info gain.length
    gain.each do |vals|
      
      r = vals/baseVal[i]
      #logger.info r*100
      #res.push((r*100).round(2))
      res.push((r.round(5)-1.00)*100)
      i += 1
    end
    
    #res.reverse!
    logger.info res.length
    logger.info res.max
    logger.info res.min
    logger.info res*","
    return res
  end
  
end
