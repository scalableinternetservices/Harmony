class ApplicationController < ActionController::Base
	logger = Logger.new(STDOUT)
	logger.level = Logger::WARN
end
