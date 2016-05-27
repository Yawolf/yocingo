defmodule Yocingo.Mixfile do
  use Mix.Project

  @description """
  This is a full Telegram Bot API. With this module you can
  create your own Telegram Bot.
  """
  
  def project do
    [app: :yocingo,
     version: "0.0.2",
     elixir: "~> 1.0",
     description: @description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:httpoison, "~> 0.8.3"},
     {:exjsx, "~> 3.2.0"},
     {:ex_doc, "~> 0.7", only: :docs},
     {:earmark, ">= 0.0.0"},
     {:markdown, github: "devinus/markdown"}]
  end

  defp package do
    [files: ["mix.exs","lib/yocingo.ex"],
     contributors: ["Santiago Cervantes","Miguel Garcia"],
     licenses: ["MIT"],
    links: %{"Github" => "https://github.com/Yawolf/yocingo"}]
  end
end

