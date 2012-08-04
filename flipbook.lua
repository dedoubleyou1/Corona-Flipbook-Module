local Flipbook = {
	mask = graphics.newMask( "mask1.png" ),
	currentPage = 1,
	pages = {},
	displayGroup = display.newGroup()
}
Flipbook.__index = Flipbook

function Flipbook:newFlipbook(newBackPage, newBackShadow, newBasicShadow, newCurlShadow) --Create a new flipbook
	local tempFlipbook = setmetatable({},self)
		-- Adds a shadow for where the curled page overlaps itself
	tempFlipbook.backShadow = display.newImage( newBackShadow )
	tempFlipbook.displayGroup:insert( tempFlipbook.backShadow )
	tempFlipbook.backShadow:setMask( self.mask )
	tempFlipbook.backShadow.y = display.contentHeight / 2
	tempFlipbook.backShadow.isVisible = false
			-- Adds a back page
	tempFlipbook.backPage = display.newImage( newBackPage )
	tempFlipbook.displayGroup:insert( tempFlipbook.backPage )
	tempFlipbook.backPage:setMask( self.mask )
	tempFlipbook.backPage.isVisible = false
		-- Adds a shadow for where the curled page overlaps the new page
	tempFlipbook.basicShadow = display.newImage( newBasicShadow )
	tempFlipbook.displayGroup:insert( tempFlipbook.basicShadow )
	tempFlipbook.basicShadow.y = display.contentHeight / 2
	tempFlipbook.basicShadow.yScale = 150
	tempFlipbook.basicShadow.xReference = -1 * tempFlipbook.basicShadow.contentWidth / 2
	tempFlipbook.basicShadow.xScale = 0.01
	tempFlipbook.basicShadow.isVisible = false
		-- Adds a shadow to give the edge of the curled page a 3d appearance
	tempFlipbook.curlShadow = display.newImage( newCurlShadow )
	tempFlipbook.displayGroup:insert( tempFlipbook.curlShadow )
	tempFlipbook.curlShadow.y = display.contentHeight / 2
	tempFlipbook.curlShadow.yScale = 150
	tempFlipbook.curlShadow.xReference = tempFlipbook.curlShadow.contentWidth / 2
	tempFlipbook.curlShadow.xScale = 0.01
	tempFlipbook.curlShadow.isVisible = false
		-- Adds event listener
	tempFlipbook.displayGroup:addEventListener( "touch", tempFlipbook )
		----
	return tempFlipbook
end

function Flipbook:addPage( newPageImage ) -- Add a new page to your flipbook
	local tempPageImage = display.newImage( newPageImage )
	tempPageImage:setMask( self.mask )
	tempPageImage.maskX = display.contentWidth
	tempPageImage.isHitTestMasked = false
	table.insert( self.pages, tempPageImage ) -- Adds new page to pages index
	self.displayGroup:insert( 1, tempPageImage ) -- Adds new page to display group
end

function Flipbook:updateCurlEffect( handleX, handleY, originY ) -- Updates the curl effect assets
	local tempX = ( handleX + ( display.contentWidth - handleX ) / 2 )
		local maskRot = math.deg (math.atan2 (originY - handleY, display.contentWidth - tempX))
		
		print( handleX, handleY, originY )
		print( tempX, maskRot )

		self.pages[self.currentPage].maskRotation = maskRot / 6
		self.pages[self.currentPage].maskX = tempX - display.contentWidth / 2

		self.backPage.xReference = display.contentWidth / 2 - tempX - 2	
		self.backPage.rotation = maskRot / 3
		self.backPage.x = tempX
		self.backPage.maskRotation = maskRot / -6
		self.backPage.maskX = display.contentWidth / 2 - tempX

		self.backShadow.xReference =  display.contentWidth / 2 - tempX
		self.backShadow.rotation = maskRot / 3
		self.backShadow.x = tempX + 10 * (handleX / display.contentWidth)
		self.backShadow.maskRotation = maskRot / -6
		self.backShadow.maskX = display.contentWidth / 2 - tempX - 10 * (handleX / display.contentWidth)

		self.curlShadow.rotation = maskRot / 6
		self.curlShadow.x = tempX
		self.curlShadow.xScale = 1.01 - handleX / display.contentWidth

		self.basicShadow.rotation = maskRot / 6
		self.basicShadow.x = tempX
		self.basicShadow.xScale = 1.01 - handleX / display.contentWidth / 3
end

function Flipbook:setAssetsVisible( isVisibleBoolean ) -- Curl effect assets visibility switch box
	self.backPage.isVisible = isVisibleBoolean
	self.backShadow.isVisible = isVisibleBoolean
	self.basicShadow.isVisible = isVisibleBoolean
	self.curlShadow.isVisible = isVisibleBoolean
end

function Flipbook:touch( event )
	if event.phase == "began" then
		if  event.xStart > 5 * display.contentWidth / 6 and self.currentPage < # self.pages or event.xStart < display.contentWidth / 6 and self.currentPage > 1 then
			if event.xStart < display.contentWidth / 6 then
				self.currentPage = self.currentPage - 1
				self.pages[self.currentPage].isVisible = true
			end
			display.getCurrentStage():setFocus( self.displayGroup )
 		   	self.isFocus = true
			self:setAssetsVisible( true )
		else
			return false
		end
	end
	if self.isFocus then
		self:updateCurlEffect( event.x, event.y, event.yStart )
        if event.phase == "ended" or event.phase == "cancelled" then
	        self:updateCurlEffect( display.contentWidth, 0, 0 )
			if math.abs(event.x - event.xStart) > display.contentWidth / 6 then
				if event.xStart > 5 * display.contentWidth / 6 and self.currentPage < # self.pages then
					self.pages[self.currentPage].isVisible = false
					self.currentPage = self.currentPage + 1
				end
				self:setAssetsVisible( false )
				display.getCurrentStage():setFocus( nil )
				self.isFocus = nil
			else
				if event.xStart < display.contentWidth / 6 and self.currentPage > 1 then
					self.pages[self.currentPage].isVisible = false
					self.currentPage = self.currentPage + 1
				end
				self:setAssetsVisible( false )
				display.getCurrentStage():setFocus( nil )
				self.isFocus = nil
			end
        end
	return true
	end
end

return Flipbook