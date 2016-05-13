defmodule Yocingo do

  @doc """
  
  This is a full Telegram Bot API. With this module you can
  create your own Telegram Bot.

  Yawolf
  https://github.com/Yawolf/yocingo
  
  """
  # The telegram bot api URL
  @api_url "https://api.telegram.org/bot"

  # This function reads the token from the file called token
  defp get_token do
    token = Application.get_env(:yocingo, :token)
    if is_nil(token) do
      {ret, body} = File.read "token"
      token = case ret do
                :ok -> String.strip((String.strip body, ?\n), ?\r) # For Linux and Windows :D
                :error -> raise File, message: "File Token not found"
              end
      Application.put_env(:yocingo, :token, token)
    end
    token
  end

  # Creates the proper API method URL
  defp build_url(method) do
    @api_url <> get_token <> "/" <>method
  end

  # Obtains and parses a petition
  defp get_response(method,request \\ []) do
    {:ok, %HTTPoison.Response{status_code: _, body: body}} =
      HTTPoison.post((build_url method), request)
    body |> JSX.decode!
  end

  # TELEGRAM API BOT FUCNTIONS

  @doc """
  A simple method for testing your bot's auth token. 
  Requires no parameters. 
  Returns basic information about the bot in form of a HashMap.

  ## Arguments
    - offset: Integer, Optional, Identifier of the first update to be returned. 
    Must be greater by one than the highest among the identifiers of previously 
    received updates. By default, updates starting with the earliest unconfirmed
    update are returned. An update is considered confirmed as soon as getUpdates
    is called with an offset higher than its update_id.
    - limits: Integer, Optional, Limits the number of updates to be retrieved. 
    Values between 1—100 are accepted. Defaults to 100
    - timeout: Integer, Optional, Timeout in seconds for long polling. 
    Defaults to 0, i.e. usual short polling
  """
  def get_me do
    "getMe" |> get_response
  end

  @doc """
  Use this method to receive incoming updates using long polling.
  Returns the updates in form of a HashMap

  ## Arguments  
    - offset: Integer, Optional, Identifier of the first update to be returned. 
    Must be greater by one than the highest among the identifiers of previously 
    received updates. By default, updates starting with the earliest unconfirmed
    update are returned. An update is considered confirmed as soon as getUpdates
    is called with an offset higher than its update_id.
    - limits: Integer, Optional, Limits the number of updates to be retrieved. 
    Values between 1—100 are accepted. Defaults to 100
    - timeout: Integer, Optional, Timeout in seconds for long polling. 
    Defaults to 0, i.e. usual short polling
  """

  def get_updates(offset \\ 0, limits \\ 100, timeout \\ 20) do
    body = {:form, [offset: offset, limits: limits, timeout: timeout]}
    get_response("getUpdates",body)
  end

  @doc """
  Use this method to send text messages.
  Retruns information in form of a HashMap.

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - text: String, Required, Text of the message to be sent.
    - disable_web_page_preview: Boolean, Optional, Disables link previews for 
    links in this message.
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).
  """

  def send_message(chat_id, text, disable_web_page_preview \\ false,
                   reply_to_mensaje_id \\ nil, reply_markup \\ %{"reply_markup" => []}) do
    body = {:form,[chat_id: chat_id,
                   text: text,
                   disable_web_page_preview: disable_web_page_preview,
                   reply_to_mensaje_id: reply_to_mensaje_id,
                   reply_markup: reply_markup |> JSX.encode!
                  ]}
    get_response("sendMessage", body)
  end

  @doc """
  forward_message:
  Use this method to forward messages of any kind.
  Returns information in form of a HashMap.

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient,
    user or group.
    - from_chat_id: Integer, Required, Unique identifier for the chat where 
    the original message was sent, user or group.
    - message_id: Unique message identifier.
  """

  def forward_message(chat_id, from_chat_id, message_id) do
    body = {:form, [chat_id: chat_id,
                    from_chat_id: from_chat_id,
                    message_id: message_id]}
    get_response("forwardMessage", body)
  end

  @doc """
  Use this method to send photos.
  Returns info in form of a HashMap

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - photo: [File | String], Required, Photo to send. You can either pass a 
    file_id as String to resend a photo that is already on the Telegram servers, 
    or upload a new photo using multipart/form-data.
    - caption: String, Optional, Photo caption (may also be used when resending
    photos by file_id).
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).
  """
  
  def send_photo(chat_id, photo, caption \\ :nil,
                 reply_to_message_id \\ :nil, reply_markup \\ :nil) do
    body = build_file({:photo, photo}, [chat_id: chat_id, caption: caption, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendPhoto", body)
  end

  @doc """
  Use this method to send audio files.
  Returns info in form of a HashMap

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - audio: [File | String], Required, Audio file to send. You can either pass a 
    file_id as String to resend a audio file that is already on the Telegram servers, 
    or upload a new photo using multipart/form-data.
    - duration: Integer, Optional, Duration of sent audio in seconds
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).
  """

  def send_audio(chat_id, audio, duration \\ 0, reply_to_message_id \\ :nil,
                 reply_markup \\ :nil) do
    body = build_file({:audio, audio}, [chat_id: chat_id, duration: duration, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendAudio", body)
  end

  @doc """
  Use this method to send documents.
  Returns info in form of a HashMap

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - document: [File | String], Required, File to send. You can either pass a 
    file_id as String to resend a document that is already on the Telegram servers, 
    or upload a new photo using multipart/form-data.
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).  
  """
  
  def send_document(chat_id, document, reply_to_message_id \\ :nil,
                    reply_markup \\ :nil) do
    body = build_file({:document, document}, [chat_id: chat_id, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendDocument", body)
  end

  @doc """
  Use this method to send documents.
  Returns info in form of a HashMap

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - sticker: [File | String], Required, Sticker to send. You can either pass a 
    file_id as String to resend a sticker that is already on the Telegram servers, 
    or upload a new photo using multipart/form-data.
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).  
  """

  def send_sticker(chat_id, sticker, reply_to_message_id \\ :nil,
                   reply_markup \\ :nil) do
    body = build_file({:sticker, sticker}, [chat_id: chat_id, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendSticker", body)
  end

  @doc """
  Use this method to send videos.
  Returns info in form of a HashMap

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - video: [File | String], Required, Video to send. You can either pass a 
    file_id as String to resend a video that is already on the Telegram servers, 
    or upload a new photo using multipart/form-data.
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).  
  """
  
  def send_video(chat_id, video, duration \\ 0, reply_to_message_id \\ :nil,
                 reply_markup \\ :nil) do
    body = build_file({:video, video}, [chat_id: chat_id, duration: duration, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendVideo", body)
  end

  @doc """
  Use this method when you need to tell the user that something is happening on the 
  bot's side. The status is set for 5 seconds or less (when a message arrives from
  your bot, Telegram clients clear its typing status).
  Returns info in form of a HashMap.

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - action: String, Required, Type of action to broadcast. Choose one, depending
    on what the user is about to receive: typing for text messages, upload_photo 
    for photos, record_video or upload_video for videos, record_audio or upload_audio
    for audio files, upload_document for general files, find_location for location data.
  """

  def send_chat_action(chat_id, action) do
    body = {:form, [chat_id: chat_id, action: action]}
    get_response("sendChatAction", body)
  end

  @doc """
  Use this method to get a list of profile pictures for a user.
  Returns info in form of a HashMap

  ## Arguments
    - user_id: Integer, Required, Unique identifier of the target user.
    - offset: Integer, Optional, Sequential number of the first photo to be returned.
    By default the value is 0 (means all).
    - limit: Integer, Optional, Limits the number of photos to be retrieved. 
    Values between 1—100 are accepted. Defaults to 100.
  """

  def get_user_profiles_photos(user_id, offset \\ 0, limit \\ 100) do
    body = {:form, [user_id: user_id,
                    offset: offset,
                    limit: limit]}
    get_response("getUserProfilePhotos", body)
  end

  @doc """
  Use this method to send point on the map.
  Returns info in form of a HashMap.

  ## Arguments
    - chat_id: Integer, Required, Unique identifier for the message recipient, 
    user or group.
    - latitude: Float, Required, Latitude of location.
    - longitude: Float, Required, Longitude of location.
    - reply_to_message_id: Integer, Optional, If the message is a reply, ID of the 
    original message.
    - reply_markup: Dict of List of List, Optional, Additional interface options. 
    A JSON-serialized object for a custom reply keyboard, instructions to hide 
    keyboard or to force a reply from the user. (Check Telegram API for more Information).
  """

  def send_location(chat_id, latitude, longitude, reply_to_message_id \\ :nil,
                    reply_markup \\ :nil) do
    body = {:form, [chat_id: chat_id,
                    latitude: to_string(latitude),
                    longitude: to_string(longitude),
                    reply_to_message_id: to_string(reply_to_message_id),
                    reply_markup: reply_markup |> JSX.encode!]}
    get_response("sendLocation", body)
  end


  # AUXILIAR FUNCTIONS

  defp is_path(path) do
    File.exists? path
  end

  defp build_multipart_file(file, others, markup \\ nil) do
    file_t = {:file, elem(file, 1),
              {"form-data",
               [{"name", to_string(elem(file, 0))},
                {"filename", Path.basename elem(file, 1)}]},
              []}
    params = Enum.map(others, fn(x) -> {to_string(elem(x, 0)), to_string(elem(x, 1))} end)
    if !is_nil(markup) do
      params = List.insert_at(params, -1, {"reply_markup", markup |> JSX.encode!})
    end
    {:multipart, List.insert_at(params, -1, file_t)}
  end

  defp build_post_file(file, others, markup \\ nil) do
    others = for {key, val} <- others, do: {key, to_string(val)}
    params = Enum.into([file], others)
    if !is_nil(markup) do
      params = Enum.into([reply_markup: (markup |> JSX.encode!)], params)
    end
    {:form, params}
  end

  defp build_file(file, others, markup \\ nil) do
    if is_path elem(file, 1) do
      build_multipart_file(file, others, markup)
    else
      build_post_file(file, others, markup)
    end
  end
end
