defmodule RabbitRecipe.ReleaseTasks do
  @moduledoc """
  Distillery Custom Commands module
  """

  @doc """
  Migrate schema
  """
  def migrate do
    {:ok, _} = Application.ensure_all_started(:rabbit_recipe)

    path = Application.app_dir(:rabbit_recipe, "priv/repo/migrations/")

    Ecto.Migrator.run(RabbitRecipe.Repo, path, :up, all: true, log: :debug)
  end

  @doc """
  Insert seed data
  """
  def seed do
    seed_path = Application.app_dir(:rabbit_recipe, "priv/repo/seeds.exs")
    Code.eval_file(seed_path)
  end
end
