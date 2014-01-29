class "CMessages"

function CMessages:__init ( )
	Events:Subscribe ( "sendCMessage", self, self.Send )
end

function CMessages:Send ( args )
	if ( args.player and type ( args.player ) == "userdata" ) then
		Network:Send ( args.player, "CMessages:receiveMessage", args )
	else
		Network:Broadcast ( "CMessages:receiveMessage", args )
	end
end

cMessages = CMessages ( )