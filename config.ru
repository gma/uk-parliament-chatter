require 'sinatra'
  
Sinatra::Application.default_options.merge!(
  :run => false,
  :env => :production,
  :public => File.join(File.dirname(__FILE__), "public"),
  :views => File.join(File.dirname(__FILE__), "views")
)
 
require 'app'
map "/uk-parliament-chatter" do
  run Sinatra.application
end
