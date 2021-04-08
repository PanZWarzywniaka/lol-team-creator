#Gems
require "sinatra"
require "require_all"
require "sinatra/reloader" # Must be removed during demonstration and final project

#include ERB::Util

require_all "controllers"
require_all "views"
