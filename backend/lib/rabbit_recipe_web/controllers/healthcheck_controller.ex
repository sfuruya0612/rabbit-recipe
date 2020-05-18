defmodule RabbitRecipeWeb.HealthcheckController do
  use RabbitRecipeWeb, :controller

  def index(conn, _params) do
    Plug.Conn.send_resp(conn, 200, "")
  end

end
