require_relative "time_format.rb"
class TimeApp
  
  
  def call(env)
    request = Rack::Request.new(env)
    format = TimeFormat.new(request.params["format"])
    
    return render_400(format.bad_formats) if format.bad_formats.any?
    
    perform_request(format)
  end
  
  private
  
  def perform_request(format)
    time = Time.now
    format_string = format.to_s
    
    response = Rack::Response.new(time.strftime(format_string), 200,  headers)
    
    response.finish
  end
  
  def headers
    {'Content-Type' => 'text/plain' }
  end
  
  def render_400(bad_formats)
    [ 400, headers, ["Unknown time format [#{bad_formats.join(',')}]\n" ]]
  end
end
