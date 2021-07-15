class App
  
  AVAILABLE_FORMATS = { "year" => {format: "%Y", delimetr: "-" },
                        "month" => {format: "%m", delimetr: "-" },
                        "day" => {format: "%d", delimetr: "-" },
                        "hour" => {format: "%H", delimetr: ":" }, 
                        "minute" => {format: "%M", delimetr: ":" }, 
                         "second" => {format: "%S", delimetr: ":" } 
                       }
  
  def call(env)
    if bad_url(env)
      return render_404
    end
    bad_formats = check_formats(env)
    if bad_formats.any?
      return render_400(bad_formats)
    end
    [status, headers, body(env)]
  end
  
  private
  
  def perform_request(env)
    time = Time.now
    format_string = ""
    prev_elem = nil
    params = env["QUERY_STRING"].split("&").map { |request| request.split("=") }.to_h
    params["format"].split("%2C").each do |format|
      if prev_elem
        if prev_elem[:delimetr] == AVAILABLE_FORMATS[format][:delimetr]
          format_string += prev_elem[:delimetr]
        else
          format_string += " " 
        end
      end
      format_string += AVAILABLE_FORMATS[format][:format]
      prev_elem = AVAILABLE_FORMATS[format]
    end
  
    
    time.strftime(format_string)
  end
  
  def status
    200
  end
  
  def headers
    {'Content-Type' => 'text/plain' }
  end
  
  def body(env)
    [perform_request(env) + "\n"]
  end
  
  def bad_url(env)
    env["PATH_INFO"] != "/time"
  end
  
  def render_404
    [ 404, {}, [] ]
  end
  
  def check_formats(env)
    params = env["QUERY_STRING"].split("&").map { |request| request.split("=") }.to_h
    params["format"].split("%2C").select do |format|
      !AVAILABLE_FORMATS.keys.include?(format) 
    end
  end
  
  def render_400(bad_formats)
    [ 400, {}, ["Unknown time format [#{bad_formats.join(',')}]\n" ]]
  end
end
