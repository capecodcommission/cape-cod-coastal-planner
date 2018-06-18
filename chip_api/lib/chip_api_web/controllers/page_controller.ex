defmodule ChipApiWeb.PageController do
  use ChipApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
