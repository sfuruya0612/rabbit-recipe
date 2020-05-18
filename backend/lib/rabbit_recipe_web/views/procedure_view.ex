defmodule RabbitRecipeWeb.ProcedureView do
  use RabbitRecipeWeb, :view
  alias RabbitRecipeWeb.ProcedureView

  def render("index.json", %{procedures: procedures}) do
    %{data: render_many(procedures, ProcedureView, "procedure.json")}
  end

  def render("show.json", %{procedure: procedure}) do
    %{data: render_one(procedure, ProcedureView, "procedure.json")}
  end

  def render("procedure.json", %{procedure: procedure}) do
    %{id: procedure.id,
      content: procedure.content,
      image: procedure.image}
  end
end
