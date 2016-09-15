defmodule Agra.Controllers.SoilFeaturesController do

 @moduledoc """
    This controller handles general requests to retrieve information on
    soil feautres and the soil topology for a given area of interest.
  """

    require Logger
    import Agra.SoilDataAcccessClient
    import Agra.SoilDataResponseParser
    import Plug.Conn

    @doc "Retrieves the soil topology for a given area of interst. An area of interest is a polygon based on
    a pair of latitude and longitude coordinates"

    def retrieve_features(conn, params) do
        Agra.SoilDataAcccessClient.start()
        response = Agra.SoilDataAcccessClient.get("", query:
                        Agra.SoilDataAcccessClient.query_params(conn.body_params))
                 |> Agra.SoilDataResponseParser.process_response
        respond(conn,  response)
    end

    @doc "Not yet implemented - retrieves a description of a given map feature."
    def retrieve_feature_description(conn, feature) do
      send_resp(conn, 200, "Not implemented" )
    end


    defp respond(conn, response_body) do
        conn |> put_resp_content_type("application/json")
        send_resp(conn, 200, Poison.encode!(response_body))
    end

end
