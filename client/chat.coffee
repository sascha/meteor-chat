Channels = new Meteor.Collection "channels"
Users = new Meteor.Collection "users"
Messages = new Meteor.Collection "messages"

Session.set 'channel_id', null
Session.set 'user_id', null

Meteor.startup () ->
	if !Session.get 'user_id'
		username = prompt("Please enter a username")
		if !username
			username = "Guest#{Math.floor(Math.random()*1000)}"
		
		user = Users.insert name: username
		Session.set 'user_id', user

Meteor.subscribe 'channels', () ->
	if !Session.get 'channel_id'
		channel = Channels.findOne {}, sort: name: 1
		Session.set 'channel_id', channel._id


Meteor.autosubscribe () ->
	channel_id = Session.get 'channel_id'
	user_id = Session.get 'user_id'
	if user_id && channel_id
		Users.update(user_id, {$set: {channel_id: channel_id}});
		Meteor.subscribe 'users', channel_id
		Meteor.subscribe 'messages', channel_id


#### Templates ####

Template.channels.channels = () ->
	Channels.find {}, sort: name: 1

Template.channels.state = () ->
	if Session.equals('channel_id', @_id) then 'disabled' else ''

Template.channels.events = {
	'click .channelBtn': (event) ->
		Session.set 'channel_id', @_id
}

Template.input.events = {
	'keyup': (event) ->
		if event.which == 13
			$inputForm = $('#footer input')
			$messageDialog = $('#messages')

			if $inputForm.val()
				Messages.insert user_id: Session.get('user_id'), channel_id: Session.get('channel_id'), text: $inputForm.val(), timestamp: new Date()
			
			$inputForm.val ""
			$inputForm.focus()

			$messageDialog.scrollTop 9999999

}

Template.users.users = () ->
	channel_id = Session.get 'channel_id'
	if !channel_id
		{}

	sel = channel_id: channel_id

	Users.find sel, sort: name: 1

Template.messages.messages = () ->
	channel_id = Session.get 'channel_id'
	if !channel_id
		{}

	sel = channel_id: channel_id
	Messages.find sel, sort: timestamp: 1