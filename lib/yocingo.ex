defmodule Yocingo do
  # The telegram bot api URL
  @api_url "https://api.telegram.org/bot"

  # This function reads the token from the file called token
  defp get_token do
    {ret, body} = File.read "token"

    case ret do
      :ok -> String.strip((String.strip body, ?\n), ?\r) # For Linux and Windows :D
      :error -> raise File, message: "File Token not found"
    end
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

  def get_me do
    "getMe" |> get_response
  end

  def get_updates(offset \\ 0, limits \\ 100, timeout \\ 20) do
    body = {:form, [offset: offset, limits: limits, timeout: timeout]}
    get_response("getUpdates",body)
  end

  def send_message(chat_id, text, disable_web_page_preview \\ false,
                   reply_to_mensaje_id \\ nil, reply_markup \\ nil) do
    body = {:form,[chat_id: chat_id,
                   text: text,
                   disable_web_page_preview: disable_web_page_preview,
                   reply_to_mensaje_id: reply_to_mensaje_id,
                   reply_markup: reply_markup |> JSX.encode!
                  ]}
    get_response("sendMessage", body)
  end

  def send_photo(chat_id, photo, caption \\ :nil,
                 reply_to_message_id \\ :nil, reply_markup \\ :nil) do
    body = build_file({:photo, photo}, [chat_id: chat_id, caption: caption, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendPhoto", body)
  end

  def send_audio(chat_id, audio, duration \\ 0, reply_to_message_id \\ :nil,
                 reply_markup \\ :nil) do
    body = build_file({:audio, audio}, [chat_id: chat_id, duration: duration, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendAudio", body)
  end

  def send_document(chat_id, document, reply_to_message_id \\ :nil,
                    reply_markup \\ :nil) do
    body = build_file({:document, document}, [chat_id: chat_id, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendDocument", body)
  end

  def send_sticker(chat_id, sticker, reply_to_message_id \\ :nil,
                   reply_markup \\ :nil) do
    body = build_file({:sticker, sticker}, [chat_id: chat_id, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendSticker", body)
  end

  def send_video(chat_id, video, duration \\ 0, reply_to_message_id \\ :nil,
                 reply_markup \\ :nil) do
    body = build_file({:video, video}, [chat_id: chat_id, duration: duration, reply_to_message_id: reply_to_message_id], reply_markup)
    get_response("sendVideo", body)
  end

  def send_chat_action(chat_id, action) do
    body = {:form, [chat_id: chat_id, action: action]}
    get_response("sendChatAction", body)
  end

  def get_user_profiles_photos(user_id, offset \\ 0, limit \\ 100) do
    body = {:form, [user_id: user_id,
                    offset: offset,
                    limit: limit]}
    get_response("getUserProfilePhotos", body)
  end

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
