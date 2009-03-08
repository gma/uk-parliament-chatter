require "rubygems"
require "sinatra"

class TwfyFinder
  def self.execute(command)
    # This method exists so we can stub it out in the specs to avoid running
    # kwexplorer during testing.
    json = `#{command}`
    raise RuntimeError.new(json.split("\n").first) unless $?.exitstatus == 0
    json
  end
  
  def initialize(options)
    @options = options
  end
  
  def command(query)
    "kwexplorer --json --twfy-minister '#{query}' --remove-subphrases #{@options}"
  end
  
  def find(query)
    TwfyFinder.execute(command(query))
  end
end

before { request.env['PATH_INFO'].gsub!(/\/$/, '') }

get "" do
  haml :index
end

get "/minister" do
  content_type :js, :charset => "utf-8" unless params[:debug]
  query = TwfyFinder.new("--min-words 2 --max-words 7")
  query.find(params[:q])
end
