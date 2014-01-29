class "CMessages"

function CMessages:__init ( )
	-- EDITABLE SETTINGS
	self.maxMessages = 10
	self.defaultTimeout = 10
	self.defaultTextColour = Color ( 255, 255, 255 )
	self.defaultRectangleColour = Color ( 0, 0, 0, 200 )

	-- DON'T TOUCH BELOW
	self.messages = { }
	self.screenSize = { Game:GetSetting ( 30 ), Game:GetSetting ( 31 ) }
	self.drawX = ( self.screenSize [ 1 ] / 2 )

	Events:Subscribe ( "sendCMessage", self, self.Send )
	Network:Subscribe ( "CMessages:receiveMessage", self, self.Send )
end

function CMessages:Send ( args )
	if ( type ( args ) == "table" ) then
		table.insert (
			self.messages,
			{
				text = args.text,
				colour = ( args.colour or self.defaultTextColour ),
				rectColour = ( args.rectColour or self.defaultRectangleColour ),
				timeout = ( args.timeout or self.defaultTimeout ),
				startTime = os.time ( )
			}
		)

		if ( not self.renderEvent ) then
			Events:Subscribe ( "PostRender", self, self.RenderMessages )
		end

		return #self.messages
	else
		return false
	end
end

function CMessages:Remove ( index )
	if ( self.messages [ index ] ) then
		table.remove ( self.messages, index )
		if ( #self.messages == 0 ) then
			if ( self.renderEvent ) then
				Events:Unsuscribe ( self.renderEvent )
			end
		end
	end
end

function CMessages:RenderMessages ( )
	local height = 15
	for index = 1, #self.messages do
		local msg = self.messages [ index ]
		if ( msg ) then
			local size = Vector2 ( self.screenSize [ 1 ] / 2, Render:GetTextHeight ( msg.text ) )
			Render:FillArea ( Vector2 ( self.drawX, height ) - size / 2, size, msg.rectColour )
			Render:DrawText ( Vector2 ( self.drawX, height + 2 ) - size / 2, tostring ( msg.text ), msg.colour, TextSize.Default, .8 )
			height = ( height + 15 )
			if ( os.time ( ) - msg.startTime == msg.timeout ) then
				self:Remove ( index )
			end
		end
	end
end

cMessages = CMessages ( )