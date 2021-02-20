defmodule ShareCodeWeb.PageController do
  use ShareCodeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
