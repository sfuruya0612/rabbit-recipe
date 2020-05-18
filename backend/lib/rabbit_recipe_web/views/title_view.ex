defmodule RabbitRecipeWeb.TitleView do
  use RabbitRecipeWeb, :view
  alias RabbitRecipeWeb.TitleView

  def render("index.json", %{titles: titles}) do
    %{data: render_many(titles, TitleView, "title.json")}
  end

  def render("show.json", %{title: title}) do
    %{data: render_one(title, TitleView, "title.json")}
  end

  def render("title.json", %{title: title}) do
    %{id: title.id,
      name: title.name,
      image: title.image,
      memo: title.memo}
  end
end
