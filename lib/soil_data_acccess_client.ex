defmodule Agra.SoilDataAcccessClient do
    require Logger
    import XmlBuilder
    use HTTPotion.Base

@base_url "http://sdmdataaccess.sc.egov.usda.gov/Spatial/SDMWGS84Geographic.wfs"
@version "1.1.0"
@request "GetFeature"
@typename "mapunitpolyextended"
@src_name "EPSG:4326"
@output_format "GML2"
@property_name "Geometry"
@service "WFS"

    @doc "Formats the area of interest into what is expected within the
    coordinates filter of the Soil Data Access system for example the
    following coordinates

    {
    'latitude_one':  37.368402,
    'longitude_one': -121.77100,
    'latitude_two': 37.373473,
    'longitude_two': -121.76000
    }

    will result in the following.
    -121.77100,37.368402 -121.76000,37.373473

    "
    defp format_coordinates(area_of_interest) do
        Enum.join([coordinates_to_string(
                     area_of_interest["longitude_one"],
                    area_of_interest["latitude_one"]
                   ),
                  coordinates_to_string(
                  area_of_interest["longitude_two"],
                  area_of_interest["latitude_two"]
                  )], " ")
    end

    @doc "Builds the filter that will be passed in the URL. The filter
    is an XML request like the following.

    <Filter>
    <BBOX>
        <PropertyName>Geometry</PropertyName>
        <Box srsName='EPSG:4326'>
            <coordinates>-121.77100,37.368402 -121.76000,37.373473</coordinates>
        </Box>
    </BBOX>
    </Filter>
    "
    defp build_filter(area_of_interest) do
  	   Logger.info "Building filter with area #{inspect area_of_interest}"

   		element(:Filter, [
   			element(:BBOX,
  			[
   			element(:PropertyName, @property_name ),
  			element(:Box,
  				%{srcName: @src_name},
  				[element(:coordinates,
  				format_coordinates(area_of_interest))])])])
  				|> generate
  	end


    @doc "Takes a latitude and longitude value and joins
    the two values by a comma. This is the format expected by the
    Soil Access API"
  	defp coordinates_to_string(latitude, longitude) do
  		Enum.join([latitude, longitude], ",")
  	end

    @doc "Creates the URL query parameters expected by the
    Soil Access API, the following is an example provided by the Soil
    Data Access Web Service.

    ?SERVICE=WFS &VERSION=1.1.0 &REQUEST=GetFeature
    &TYPENAME=MapunitPoly &FILTER=<Filter><BBOX><PropertyName>Geometry</PropertyName>
    <Box srsName='EPSG:4326'> <coordinates>-121.77100,37.368402 -121.76000,37.373473</coordinates>
     </Box></BBOX></Filter> &SRSNAME=EPSG:4326 &OUTPUTFORMAT=GML2
    "
  	def query_params(area_of_interest) do
  	    Logger.info "AreaOfInterest #{inspect area_of_interest}"
      	query_ps = %{SERVICE: @service,
      	  VERSION: @version,
      	  REQUEST: @request,
      	  TYPENAME: @typename,
      	  FILTER: build_filter(area_of_interest),
      	  SRSNAME: @src_name,
      	  OUTPUTFORMAT: @output_format}
      end


      def process_url(url) do
    		@base_url <> url
      end


end
