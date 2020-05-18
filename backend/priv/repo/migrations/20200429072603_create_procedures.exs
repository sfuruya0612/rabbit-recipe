defmodule RabbitRecipe.Repo.Migrations.CreateProcedures do
  use Ecto.Migration

  def change do
    create table(:procedures) do
      add :content, :text
      add :image, :string

      timestamps()
    end

  end
end
