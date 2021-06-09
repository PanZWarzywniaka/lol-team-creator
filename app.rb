#Gems
require "sinatra"
require "require_all"
require "sinatra/reloader"
require "uri"
require "net/http"


include ERB::Util

require_all "controllers"
require_all "views"
