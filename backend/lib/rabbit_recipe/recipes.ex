defmodule RabbitRecipe.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias RabbitRecipe.Repo

  alias RabbitRecipe.Recipes.Title
  alias RabbitRecipe.Recipes.Procedure
  alias RabbitRecipe.Recipes.Ingredients

  @doc """
  Returns the list of titles.

  ## Examples

      iex> list_titles()
      [%Title{}, ...]

  """
  def list_titles do
    Repo.all(Title)
  end

  @doc """
  Gets a single title.

  Raises `Ecto.NoResultsError` if the Title does not exist.

  ## Examples

      iex> get_title!(123)
      %Title{}

      iex> get_title!(456)
      ** (Ecto.NoResultsError)

  """
  def get_title!(id), do: Repo.get!(Title, id)

  @doc """
  Creates a title.

  ## Examples

      iex> create_title(%{field: value})
      {:ok, %Title{}}

      iex> create_title(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_title(attrs \\ %{}) do
    %Title{}
    |> Title.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a title.

  ## Examples

      iex> update_title(title, %{field: new_value})
      {:ok, %Title{}}

      iex> update_title(title, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_title(%Title{} = title, attrs) do
    title
    |> Title.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a title.

  ## Examples

      iex> delete_title(title)
      {:ok, %Title{}}

      iex> delete_title(title)
      {:error, %Ecto.Changeset{}}

  """
  def delete_title(%Title{} = title) do
    Repo.delete(title)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking title changes.

  ## Examples

      iex> change_title(title)
      %Ecto.Changeset{source: %Title{}}

  """
  def change_title(%Title{} = title) do
    Title.changeset(title, %{})
  end

  @doc """
  Returns the list of procedures.

  ## Examples

      iex> list_procedures()
      [%Procedure{}, ...]

  """
  def list_procedures do
    Repo.all(Procedure)
  end

  @doc """
  Gets a single procedure.

  Raises `Ecto.NoResultsError` if the Procedure does not exist.

  ## Examples

      iex> get_procedure!(123)
      %Procedure{}

      iex> get_procedure!(456)
      ** (Ecto.NoResultsError)

  """
  def get_procedure!(id), do: Repo.get!(Procedure, id)

  @doc """
  Creates a procedure.

  ## Examples

      iex> create_procedure(%{field: value})
      {:ok, %Procedure{}}

      iex> create_procedure(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_procedure(attrs \\ %{}) do
    %Procedure{}
    |> Procedure.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a procedure.

  ## Examples

      iex> update_procedure(procedure, %{field: new_value})
      {:ok, %Procedure{}}

      iex> update_procedure(procedure, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_procedure(%Procedure{} = procedure, attrs) do
    procedure
    |> Procedure.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a procedure.

  ## Examples

      iex> delete_procedure(procedure)
      {:ok, %Procedure{}}

      iex> delete_procedure(procedure)
      {:error, %Ecto.Changeset{}}

  """
  def delete_procedure(%Procedure{} = procedure) do
    Repo.delete(procedure)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking procedure changes.

  ## Examples

      iex> change_procedure(procedure)
      %Ecto.Changeset{source: %Procedure{}}

  """
  def change_procedure(%Procedure{} = procedure) do
    Procedure.changeset(procedure, %{})
  end

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredients{}, ...]

  """
  def list_ingredients do
    Repo.all(Ingredients)
  end

  @doc """
  Gets a single ingredients.

  Raises `Ecto.NoResultsError` if the Ingredients does not exist.

  ## Examples

      iex> get_ingredients!(123)
      %Ingredients{}

      iex> get_ingredients!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredients!(id), do: Repo.get!(Ingredients, id)

  @doc """
  Creates a ingredients.

  ## Examples

      iex> create_ingredients(%{field: value})
      {:ok, %Ingredients{}}

      iex> create_ingredients(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredients(attrs \\ %{}) do
    %Ingredients{}
    |> Ingredients.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredients.

  ## Examples

      iex> update_ingredients(ingredients, %{field: new_value})
      {:ok, %Ingredients{}}

      iex> update_ingredients(ingredients, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredients(%Ingredients{} = ingredients, attrs) do
    ingredients
    |> Ingredients.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredients.

  ## Examples

      iex> delete_ingredients(ingredients)
      {:ok, %Ingredients{}}

      iex> delete_ingredients(ingredients)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredients(%Ingredients{} = ingredients) do
    Repo.delete(ingredients)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredients changes.

  ## Examples

      iex> change_ingredients(ingredients)
      %Ecto.Changeset{source: %Ingredients{}}

  """
  def change_ingredients(%Ingredients{} = ingredients) do
    Ingredients.changeset(ingredients, %{})
  end
end
