defmodule Agra.SoilDataResponseParser do
  	import SweetXml
 @moduledoc """
 This parses the response from the Soil Data Access Web Service
 and reformats the XML into JSON. The JSON is very similar to
 what is expected by the Google Maps API for displaying
 polygons on a map.

 """

 @doc "Splits a latitude/longitude tuple into a map which will be encoded to JSON "
      defp to_lat_lng_entry(lat_long) do
      	%{lat: hd(lat_long), lng: List.last(lat_long)}
      end

@doc "Applies a function to all the coordinates which splits a tuple
    into a map of latitude and longitude coordinates"
     defp format_coordinate_list(coordinate_lists) do
        	Enum.map coordinate_lists, fn x -> to_lat_lng_entry(x) end
      end

@doc "The coordinates returned from the Soil Data Access Web Service are returned as text within an XML element.
      The value of the element is like the following.

        37.381394,-121.781042 37.381394,-121.780993

      General this string of coordinates is quite large. This function splits the coordinate test into a list of
      elements and then partitions the list into lists of 2 (latitude and longitude). The
      list of lists is then reformatted into a map of latitude and longitude pairs"
      defp parse_coordinates(coordinates) do
  	    result = coordinates
  	        |> to_string
  	        |> String.split([","," "])
  	        |> Enum.chunk(2)
  	    format_coordinate_list(result)
      end

@doc "Updates the feature coordinates to reflect a cleaner map structure rather than a large
    string of coordinates"
      defp update_feature_coordinates(feature) do
         update_in(feature.coordinates, &(parse_coordinates(&1)))
      end

@doc "Iterates of all the features and reformats the features into a cleaner map structure that
will be encoded to JSON"
      defp reformat_features(unformatted_features) do
                Enum.map unformatted_features, fn x -> update_feature_coordinates(x) end
      end


@doc "Parses a subset of the XML fields. Most importantly it retrieves the
soil type, and the cooridinates for creating the polynomial"
      defp parse_xml_fields(body) do
        body |> xpath(~x"//wfs:FeatureCollection/gml:featureMember"l,
                               coordinates: ~x"//ms:mapunitpolyextended/
                                                 ms:multiPolygon/gml:MultiPolygon/
                                                 gml:polygonMember/
                                                 gml:Polygon/
                                                 gml:outerBoundaryIs/
                                                 gml:LinearRing/
                                                 gml:coordinates/text()",
                               name: ~x"//ms:muname/text()",
                               drainClass: ~x"//ms:drclassdcd/text()")
      end

@doc "Processes the XML response returned from the Soil Access Web Service and
    returns a map structure which can be encoded into JSON."
      def process_response(response) do
         %{area_of_interest: response.body
         |> xpath(~x"//gml:boundedBy/gml:Box/gml:coordinates/text()")
         |> parse_coordinates,
            features: response.body
                       |> parse_xml_fields
                       |> reformat_features}
      end

end
