#-------------------------------------------------------------------------------
#
# Message - Objects and windows
#
#-------------------------------------------------------------------------------
module ContestHall
	class NewMethod
		
		def pbCustomMessage(message, skin=nil, newx=nil, newwidth=nil, &block)
			ret = 0
			msgwindow = pbCreateMessageWindow(nil,skin)
			msgwindow.x = newx if !newx.nil?
			msgwindow.width = newwidth.nil? ? (Graphics.width - msgwindow.x) : newwidth
			pbMessageDisplayContest(msgwindow, message, &block)
			pbDisposeMessageWindow(msgwindow)
			Input.update
			return ret
		end

	end
end