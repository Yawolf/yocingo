defmodule Yocingo do
  @api_url "https://api.telegram.org/bot"

  def get_token do
    {ret,body} = File.read! "token"

    case ret do
      :ok -> body
      :error -> raise File, message: "File Token not found"
    end
    
  end

  def build_url(method) do
    @api_url <> get_token <> method 
  end

  # def get_response(method,request \\ :Nothing) do
  #   case request do
  #     :Noting -> 
  #   end
      
  # end
    
end
