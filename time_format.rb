class TimeFormat
  
  AVAILABLE_FORMATS = { "year" => {format: "%Y", delimetr: "-" },
                        "month" => {format: "%m", delimetr: "-" },
                        "day" => {format: "%d", delimetr: "-" },
                        "hour" => {format: "%H", delimetr: ":" }, 
                        "minute" => {format: "%M", delimetr: ":" }, 
                         "second" => {format: "%S", delimetr: ":" } 
                       }
                       
  def initialize(format_string)
    @formats = format_string.split(",")
  end
  
  def bad_formats
    @bad_formats ||= @formats.select do |format|
      !AVAILABLE_FORMATS.keys.include?(format) 
    end
  end
  
  def to_s
    prev_elem = nil   
    format_string = ""
    
    @formats.each do |format| 
      if prev_elem&.dig(:delimetr) == AVAILABLE_FORMATS[format][:delimetr]
          format_string += prev_elem[:delimetr]
      elsif prev_elem
        format_string += " " 
      end
      format_string += AVAILABLE_FORMATS[format][:format]
      prev_elem = AVAILABLE_FORMATS[format]
    end
    format_string + "\n"
  end
end