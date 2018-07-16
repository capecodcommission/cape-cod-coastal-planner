defmodule ChipApiWeb.Router do
  use ChipApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:3000"
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: ChipApiWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ChipApiWeb.Schema,
      interface: :simple
  end
end
