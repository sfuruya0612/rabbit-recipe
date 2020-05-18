defmodule RabbitRecipe.Repo.Migrations.CreateTitles do
  use Ecto.Migration

  def change do
    create table(:titles) do
      add :name, :string
      add :image, :string
      add :memo, :text

      timestamps()
    end

    create unique_index(:titles, [:name])
  end
end
