defmodule RabbitRecipe.Recipes.Title do
  use Ecto.Schema
  import Ecto.Changeset

  schema "titles" do
    field :image, :string
    field :memo, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(title, attrs) do
    title
    |> cast(attrs, [:name, :image, :memo])
    |> validate_required([:name, :image, :memo])
    |> unique_constraint(:name)
  end
end
