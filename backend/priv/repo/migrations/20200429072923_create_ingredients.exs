defmodule RabbitRecipe.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :text
      add :amount, :string

      timestamps()
    end

  end
end
