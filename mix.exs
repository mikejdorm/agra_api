defmodule AgraApi.Mixfile do
  use Mix.Project

  def project do
    [app: :agra_api,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
  [applications: [:cowboy, :plug],
   mod: {AgraApi, []},
   env: [cowboy_port: 5454]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:sweet_xml, "~> 0.6.1"},
                {:httpotion, "~> 3.0.0"},
                {:xml_builder, "~> 0.0.6"},
                {:cowboy, "~> 1.0.0"},
                {:plug, "~> 1.0"},
                {:jazz, github: "meh/jazz"},
                {:ja_serializer, "~> 0.11.0"}]
  end
end
