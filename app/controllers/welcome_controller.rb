class WelcomeController < ApplicationController
	def index 
		UserMailer.publish_lesson('naitnix@126.com').deliver
	end
	def tel
	end
end