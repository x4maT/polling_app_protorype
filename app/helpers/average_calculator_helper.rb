module AverageCalculatorHelper

  def avg(arr) arr.any? ? arr.reduce(:+)/arr.size.to_f : 0.0 end


  def calc_average(solution)
    data = []
    puts '---------------------------CALCULATING AVERAGE----------------------------'
    data = solution
    puts solution[0]

    h = solution.each_with_object ( Hash.new { |h,k| h[k]=[] } ) { |mh,h|
      mh.keys.each { |k| h[k] << mh[k].to_f unless mh[k].empty? } }

    total = []
    h.each_with_object({}) { |(k,v),h|
    # h[k] = ( avg(v) arr.any? ? arr.reduce(:+)/arr.size.to_f : 0.0 }
    h[k] = avg(v)
    total = h
    }
    puts '--------------------------TOTAL RESULT-------------------------------------'
    puts total
    puts '---------------------------------------------------------------------------'
    # data << {solution_id:k, percentage: ((v.to_f / solution.count) * 100)}
    return total
  end
end
