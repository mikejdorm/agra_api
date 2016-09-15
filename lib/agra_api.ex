defmodule AgraApi do
      use Application

      def start(_type, _args) do
        port = Application.get_env(:agra_api, :cowboy_port, 5454)

        children = [
          Plug.Adapters.Cowboy.child_spec(:http, Agra.Routers.AppRouter, [], port: port)
        ]

        Supervisor.start_link(children, strategy: :one_for_one)
      end
end
