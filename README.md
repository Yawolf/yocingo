![](http://s13.postimg.org/7vkml9zwn/yocingo_Icon.png)

Yocingo Telegram API Bot
========================

A Telegram API Bot written in **Elixir**! Awesome! :D ([Hex](https://hex.pm/packages/yocingo)) ([Documentation](http://hexdocs.pm/yocingo/0.0.1/))

The libary is completed!! Yay! And it is accesible in the Hex repository! ^_^

## Disclaimer
This is my first Elixir program, so please, don't be hard with me, I'm just a poor
boy who loves learn new things :D

Every comment or suggestion is welcome!

## Install
Use Mix to install this module, add:

```elixir
defp deps do
    [{:yocingo, ">= 0.0.1"}]
end
```
In your mix.exs deps function and then type:

```
$ mix deps.get
```
And finally add yocingo as an application dependency:

```elixir
defp application do
    [applications: [:yocingo]]
end
```
And done! You can use Yocingo in your project :D

## How it Works?
Well this is a complete implementation of the Telegram Bot API in Elixir, and it
is really easy to use the functions.

### get_me
A simple method for testing your bot's auth token. 
Requires no parameters. 
Returns basic information about the bot in form of a HashMap.

Example:

```elixir
iex> Yocingo.get_me
%{"ok" => true,
"result" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}}
```

### get_updates
Use this method to receive incoming updates using long polling.
Returns the updates in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
offset | Integer | Optional | Identifier of the first update to be returned. Must be greater by one than the highest among the identifiers of previously received updates. By default, updates starting with the earliest unconfirmed update are returned. An update is considered confirmed as soon as getUpdates is called with an offset higher than its update_id.
limits | Integer | Optional | Limits the number of updates to be retrieved. Values between 1—100 are accepted. Defaults to 100
timeout | Integer | Optional | Timeout in seconds for long polling. Defaults to 0, i.e. usual short polling

Example:

```elixir
iex> Yocingo.get_updates 965421280
%{"ok" => true,
"result" => [%{"message" => %{"chat" => %{"first_name" => "Yago",
"id" => 8026522, "last_name" => "Wolf", "username" => "ygwolf"},
"date" => 1438340483,
"from" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "message_id" => 53,
"text" => "a"}, "update_id" => 965421280}]}
```


### send_message
Use this method to send text messages.
Retruns information in form of a HashMap.

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
text | String | Yes | Text of the message to be sent.
disable_web_page_preview | Boolean | Optional | Disables link previews for links in this message.
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional | Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).

Example:

```elixir
iex> Yocingo.send_message 8026522, "Hi there! How are you doing?"
%{"ok" => true,
"result" => %{"chat" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "date" => 1438343887,
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}, "message_id" => 57,
"text" => "Hi there! How are you doing?"}}
```

### send_photo
Use this method to send photos.
Returns info in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
photo | File or String | Yes | Photo to send. You can either pass a file_id as String to resend a photo that is already on the Telegram servers, or upload a new photo using multipart/form-data.
caption | String | Optional | Photo caption (may also be used when resending photos by file_id).
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional, Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).

Example:

```elixir
iex> Yocingo.send_photo 8026522, "yocingoIcon.png"
%{"ok" => true,
"result" => %{"chat" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "date" => 1438344612,
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}, "message_id" => 58,
"photo" => [%{"file_id" => "AgADBAADq6cxG16RjwWKV2xn40AI6l4NUTAABAKa55-TYmeR6tcBAAEC",
"file_size" => 1415, "height" => 90, "width" => 57},
%{"file_id" => "AgADBAADq6cxG16RjwWKV2xn40AI6l4NUTAABJDV8MqvvYi66dcBAAEC",
"file_size" => 6928, "height" => 245, "width" => 156}]}}
```

### send_audio
Use this method to send audio files.
Returns info in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
audio | File or String | Yes | Audio file to send. You can either pass a file_id as String to resend a audio file that is already on the Telegram servers, or upload a new photo using multipart/form-data.
duration | Integer | Optional | Duration of sent audio in seconds
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional | Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).

Example:

```elixir
iex> Yocingo.send_audio 8026522, "example.ogg"
%{"ok" => true,
"result" => %{"audio" => %{"duration" => 0,
"file_id" => "AwADBAADBgADXpGPBfhLd55LsVpQAg", "file_size" => 105243,
"mime_type" => "audio/ogg"},
"chat" => %{"first_name" => "Yago", "id" => 8026522, "last_name" => "Wolf",
"username" => "ygwolf"}, "date" => 1438344843,
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}, "message_id" => 59}}
```

### send_document
Use this method to send documents.
Returns info in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
sticker | File or String | Yes | Sticker to send. You can either pass a file_id as String to resend a sticker that is already on the Telegram servers, or upload a new photo using multipart/form-data.
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional | Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).

Example:

```elixir
iex> Yocingo.send_document 8026522, ".gitignore"
%{"ok" => true,
"result" => %{"chat" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "date" => 1438345187,
"document" => %{"file_id" => "BQADBAADBwADXpGPBcyn2H9KLwekAg",
"file_name" => ".gitignore", "file_size" => 84},
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}, "message_id" => 60}}
```

### send_sticker
Use this method to send documents.
Returns info in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
sticker | File or String | Yes | Sticker to send. You can either pass a file_id as String to resend a sticker that is already on the Telegram servers, or upload a new photo using multipart/form-data.
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional | Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).

Example:

```elixir
iex> Yocingo.send_sticker 8026522, "BQADBAADgwADXOgKAAF8NJdrPGQ5agI"
%{"ok" => true,
"result" => %{"chat" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "date" => 1438345343,
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}, "message_id" => 62,
"sticker" => %{"file_id" => "BQADBAADgwADXOgKAAF8NJdrPGQ5agI",
"file_size" => 27954, "height" => 512,
"thumb" => %{"file_id" => "AAQEABP-lGEwAAR35Im92KU34gYrAAIC",
"file_size" => 5542, "height" => 128, "width" => 109}, "width" => 436}}}
```

### send_video
Use this method to send videos.
Returns info in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
video | File or String | Yes, Video to send. You can either pass a file_id as String to resend a video that is already on the Telegram servers, or upload a new photo using multipart/form-data.
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional | Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).  

Example:

```elixir
iex> Yocingo.send_sticker 8026522, "sample.mp4"
%{"ok" => true,
"result" => %{"chat" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "date" => 1438360135,
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"}, "message_id" => 63,
"sticker" => %{"file_id" => "BQADBAADCAADXpGPBQTGPdRE9IOZAg",
"file_size" => 1055736, "height" => 0, "width" => 0}}}
```

### send_chat_action:
Use this method when you need to tell the user that something is happening on the 
bot's side. The status is set for 5 seconds or less (when a message arrives from
your bot, Telegram clients clear its typing status).
Returns info in form of a HashMap.

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
action | String | Yes | Type of action to broadcast. Choose one, depending on what the user is about to receive: typing for text messages, upload_photo for photos, record_video or upload_video for videos, record_audio or upload_audio for audio files, upload_document for general files, find_location for location data.

Exmaple:

```elixir
iex> Yocingo.send_chat_action 8026522, "typing"
%{"ok" => true, "result" => true}
```

### get_use_profiles_photos:
Use this method to get a list of profile pictures for a user.
Returns info in form of a HashMap

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
user_id | Integer | Yes | Unique identifier of the target user.
offset | Integer | Optional | Sequential number of the first photo to be returned. By default the value is 0 (means all).
limit | Integer | Optional | Limits the number of photos to be retrieved. Values between 1—100 are accepted. Defaults to 100.

Example:

```elixir
iex> Yocingo.get_user_profiles_photos 1
%{"ok" => true, "result" => %{"photos" => [], "total_count" => 0}}
```

### send_location
Use this method to send point on the map.
Returns info in form of a HashMap.

**Arguments**

Name | Type | Required | Description
-----|------|----------|-------------
chat_id | Integer | Yes | Unique identifier for the message recipient, user or group.
latitude | Float | Yes | Latitude of location.
longitude | Float | Yes | Longitude of location.
reply_to_message_id | Integer | Optional | If the message is a reply, ID of the original message.
reply_markup | Dict of List of List | Optional | Additional interface options. A JSON-serialized object for a custom reply keyboard, instructions to hide keyboard or to force a reply from the user. (Check Telegram API for more Information).

Example:

```elixir
iex> Yocingo.send_location 8026522, 40.4000, -3.7167
%{"ok" => true,
"result" => %{"chat" => %{"first_name" => "Yago", "id" => 8026522,
"last_name" => "Wolf", "username" => "ygwolf"}, "date" => 1438360680,
"from" => %{"first_name" => "RaggerBot", "id" => 93294942,
"username" => "RaggerBot"},
"location" => %{"latitude" => 40.400003, "longitude" => -3.716695},
"message_id" => 64}}
```

Have you seen? Is really easy to use! :D

## Contact
Use telegram to talk about Telegram! :D
[ygwolf](https://telegram.me/ygwolf)
