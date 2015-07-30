defmodule Yocingo do
  # The telegram bot api URL
  @api_url "https://api.telegram.org/bot"

  # This function reads the token from the file called token
  def get_token do
    {ret, body} = File.read "token"

    case ret do
      :ok -> String.strip body, ?\n
      :error -> raise File, message: "File Token not found"
    end

  end

  # Creates the proper API method URL
  def build_url(method) do
    @api_url <> get_token <> "/" <>method
  end

  # Obtains and parses a petition
  def get_response(method,request \\ :nil) do
    case request do
      :nil ->
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} =
        HTTPoison.get build_url method
        body |> JSX.decode!
      _ ->
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} =
        HTTPoison.post((build_url method), request)
        body |> JSX.decode!
    end
  end

  # TELEGRAM API BOT FUCNTIONS

  def get_me do
    "getMe" |> get_response
  end

  def get_updates do
    "getUpdates" |> get_response
  end

  def get_updates(offset \\ 0, limit \\ 100, timeout \\ 20) do
    body = {:form, [offset: offset, limit: limit, timeout: timeout]}
    get_response("getUpdates", body)
  end

  def send_message(chat_id, text, disable_web_page_preview \\ false,
      reply_to_mensaje_id \\ nil, reply_markup \\ nil) do
    body = {:form,[chat_id: chat_id, text: text]}
    get_response("sendMessage", body)
  end

end
