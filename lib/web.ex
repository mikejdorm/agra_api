defmodule Agra.Web do
  @moduledoc false
  def controller do
    quote do
      use Phoenix.Controller
      import ApiRouter.Router.Helpers
    end
  end

  def router do
    quote do
      use Plug.Router
      require Logger
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
