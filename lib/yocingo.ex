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
    "http://localhost:5000/"
    @api_url <> get_token <> "/" <>method
  end

  # Obtains and parses a petition

  def get_response(method,request \\ []) do
    {:ok, %HTTPoison.Response{status_code: code, body: body}} =
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
    body = {:form,[chat_id: chat_id, text: text]}
    get_response("sendMessage", body)
  end

  def send_photo(chat_id, photo_path) do
    looks_like = (length String.split(photo_path, ".")) > 1
    if looks_like do
      send_photo_path(chat_id, photo_path)
    else
      send_photo_id(chat_id, photo_path)
    end
  end

  # AUXILIAR FUNCTIONS

  def send_photo_path(chat_id, photo_path) do
    fname = String.split(photo_path, "/") |> List.last
    multipartbody = {:multipart,
                     [{"chat_id", to_string(chat_id)},
                      {:file, photo_path,
                       {"form-data",
                        [{"name", "photo"},
                         {"filename", fname}]},
                       []}]}

    url = build_url "sendPhoto"
    body = case :hackney.post(url, [], multipartbody) do
             {:ok, status_code, headers, client} when status_code in [204, 304] -> "{}"
             {:ok, status_code, headers} -> "{}"
             {:ok, status_code, headers, client} ->
               case :hackney.body(client) do
                 {:ok, body} -> body
                 {:error, reason} -> "{}"
               end
             {:ok, id} -> "{}"
             {:error, reason} -> "{}"
           end
    body |> JSX.decode!
  end

  def send_photo_id(chat_id, photo_id) do
    body = {:form, [chat_id: chat_id, photo: photo_id]}
    get_response("sendPhoto", body)
  end

end
