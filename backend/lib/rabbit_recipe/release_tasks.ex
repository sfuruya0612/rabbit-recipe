defmodule RabbitRecipe.ReleaseTasks do

  def migrate do
    {:ok, _} = Application.ensure_all_started(:rabbit_recipe)

    path = Application.app_dir(:rabbit_recipe, "priv/repo/migrations")

    Ecto.Migrator.run(RabbitRecipe.Repo, path, :up, all: true)
  end

  def seed do
    seed_path = Application.app_dir(:rabbit_recipe, "priv/repo/seeds.exs")
    Code.eval_file(seed_path)
  end
end
