defmodule RabbitRecipe.Recipes.Procedure do
  use Ecto.Schema
  import Ecto.Changeset

  schema "procedures" do
    field :content, :string
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(procedure, attrs) do
    procedure
    |> cast(attrs, [:content, :image])
    |> validate_required([:content, :image])
  end
end
