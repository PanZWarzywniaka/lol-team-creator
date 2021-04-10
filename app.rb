#Gems
require "sinatra"
require "require_all"
require "sinatra/reloader"
require 'httparty'


#include ERB::Util

require_all "controllers"
require_all "views"
