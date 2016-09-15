defmodule Agra.Routers.AppRouter do
  require Logger
  use Agra.Web, :router

    plug Plug.Logger
    plug :match
    plug :dispatch

     def init(options) do
         options
      end

    forward "/api", to: Agra.Routers.ApiRouter

    match _ do
      Logger.info "No match found"
      send_resp(conn, 404, "oops")
    end

end
