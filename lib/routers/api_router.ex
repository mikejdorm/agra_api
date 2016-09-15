defmodule Agra.Routers.ApiRouter do
      import Plug.Conn
      import Plug.Conn.Utils
      use Agra.Web, :router
      plug JaSerializer.ContentTypeNegotiation
      plug Plug.Parsers, parsers: [Plug.Parsers.JSON], json_decoder: Poison
      plug JaSerializer.Deserializer

      plug :match
      plug :dispatch

      post "/soil/features" do
        Agra.Controllers.SoilFeaturesController.retrieve_features(conn, conn.params)
      end

      get "/soil/features/describe/:feature" do
        Agra.Controllers.SoilFeaturesController.retrieve_feature_description(conn, feature)
      end

end
