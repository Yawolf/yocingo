defmodule Yocingo do
  # The telegram bot api URL
  @api_url "https://api.telegram.org/bot"

  # This function reads the token from the file called token
  def get_token do
    {ret, body} = File.read "token"

    case ret do
      :ok -> String.strip((String.strip body, ?\n), ?\r) # For Linux and Windows :D
      :error -> raise File, message: "File Token not found"
    end

  end

  # Creates the proper API method URL
  def build_url(method) do
    @api_url <> get_token <> "/" <>method
  end

  # Obtains and parses a petition

  def get_response(method,request \\ []) do
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
    if is_path photo do
      body = {:multipart,
              [{"chat_id", to_string(chat_id)},
               {"caption", to_string(caption)},
               {"reply_to_message_id", to_string(reply_to_message_id)},
               {"reply_markup", reply_markup |> JSX.encode!},
               {:file, photo,
                {"form-data",
                 [{"name", "photo"},
                  {"filename", Path.basename photo}]},
                []}]}
    else
      body = {:form, [chat_id: chat_id,
                      photo: photo,
                      caption: to_string(caption),
                      reply_to_message_id: to_string(reply_to_message_id),
                      reply_markup: reply_markup |> JSX.encode!]}
    end
    get_response("sendPhoto", body)
  end

  def send_audio(chat_id, audio, duration \\ 0, reply_to_message_id \\ :nil,
                 reply_markup \\ :nil) do
    if is_path audio do
      body = {:multipart,
              [{"chat_id", to_string(chat_id)},
               {"duration", to_string(duration)},
               {"reply_to_message_id", to_string(reply_to_message_id)},
               {"reply_markup", reply_markup |> JSX.encode!},
               {:file, audio,
                {"form-data",
                 [{"name", "audio"},
                  {"filename", Path.basename audio}]},
                []}]}
    else
      body = {:form, [chat_id: chat_id,
                      audio: audio,
                      duration: to_string(duration),
                      reply_to_message_id: to_string(reply_to_message_id),
                      reply_markup: reply_markup |> JSX.encode!]}
    end
    get_response("sendAudio", body)
  end
  
  # AUXILIAR FUNCTIONS

  def is_path(path) do
    File.exists? path
  end

end
