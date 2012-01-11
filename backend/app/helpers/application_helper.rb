module ApplicationHelper
  def image_area_to_css percentages
    "top: #{percentages[0]}%; left: #{percentages[1]}%; width: #{percentages[2]}%; height: #{percentages[3]}%"
    
  end
end
