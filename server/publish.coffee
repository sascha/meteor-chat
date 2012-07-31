# Channels -- {name: String}
Channels = new Meteor.Collection "channels"

Meteor.publish "channels", () ->
	Channels.find()

# Users -- {name: String, channel_id: String}
Users = new Meteor.Collection "users"

Meteor.publish "users", (channel_id) ->
	Users.find channel_id: channel_id

# Message -- {user_id: String, channel_id: String, text: String, timestamp: Number}
Messages = new Meteor.Collection "messages"

Meteor.publish "messages", (channel_id) ->
	Messages.find channel_id: channel_id