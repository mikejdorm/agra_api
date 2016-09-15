defmodule FeatureRequestSerializer do
  use JaSerializer, dsl: true
  location "/soil/features"
    attributes [:latitudeOne, :longitudeOne, :latitudeTwo, :longitudeTwo]

  def excerpt(post, _conn) do
    [first | _ ] = String.split(post.body, ".")
    first
  end

end
