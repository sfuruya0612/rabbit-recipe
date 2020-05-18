defmodule RabbitRecipe.Recipes.Ingredients do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredients" do
    field :amount, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(ingredients, attrs) do
    ingredients
    |> cast(attrs, [:name, :amount])
    |> validate_required([:name, :amount])
  end
end
