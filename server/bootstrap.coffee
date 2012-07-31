# if database is empty on server start, create some channels

Meteor.startup () ->
	if Channels.find().count() == 0
		data = ["Meteor", "Javascript", "Objective-C"]
		Channels.insert name: channel for channel in data