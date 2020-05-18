defmodule RabbitRecipe.RecipesTest do
  use RabbitRecipe.DataCase

  alias RabbitRecipe.Recipes

  describe "titles" do
    alias RabbitRecipe.Recipes.Title

    @valid_attrs %{image: "some image", memo: "some memo", name: "some name"}
    @update_attrs %{image: "some updated image", memo: "some updated memo", name: "some updated name"}
    @invalid_attrs %{image: nil, memo: nil, name: nil}

    def title_fixture(attrs \\ %{}) do
      {:ok, title} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_title()

      title
    end

    test "list_titles/0 returns all titles" do
      title = title_fixture()
      assert Recipes.list_titles() == [title]
    end

    test "get_title!/1 returns the title with given id" do
      title = title_fixture()
      assert Recipes.get_title!(title.id) == title
    end

    test "create_title/1 with valid data creates a title" do
      assert {:ok, %Title{} = title} = Recipes.create_title(@valid_attrs)
      assert title.image == "some image"
      assert title.memo == "some memo"
      assert title.name == "some name"
    end

    test "create_title/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_title(@invalid_attrs)
    end

    test "update_title/2 with valid data updates the title" do
      title = title_fixture()
      assert {:ok, %Title{} = title} = Recipes.update_title(title, @update_attrs)
      assert title.image == "some updated image"
      assert title.memo == "some updated memo"
      assert title.name == "some updated name"
    end

    test "update_title/2 with invalid data returns error changeset" do
      title = title_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_title(title, @invalid_attrs)
      assert title == Recipes.get_title!(title.id)
    end

    test "delete_title/1 deletes the title" do
      title = title_fixture()
      assert {:ok, %Title{}} = Recipes.delete_title(title)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_title!(title.id) end
    end

    test "change_title/1 returns a title changeset" do
      title = title_fixture()
      assert %Ecto.Changeset{} = Recipes.change_title(title)
    end
  end

  describe "procedures" do
    alias RabbitRecipe.Recipes.Procedure

    @valid_attrs %{content: "some content", image: "some image"}
    @update_attrs %{content: "some updated content", image: "some updated image"}
    @invalid_attrs %{content: nil, image: nil}

    def procedure_fixture(attrs \\ %{}) do
      {:ok, procedure} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_procedure()

      procedure
    end

    test "list_procedures/0 returns all procedures" do
      procedure = procedure_fixture()
      assert Recipes.list_procedures() == [procedure]
    end

    test "get_procedure!/1 returns the procedure with given id" do
      procedure = procedure_fixture()
      assert Recipes.get_procedure!(procedure.id) == procedure
    end

    test "create_procedure/1 with valid data creates a procedure" do
      assert {:ok, %Procedure{} = procedure} = Recipes.create_procedure(@valid_attrs)
      assert procedure.content == "some content"
      assert procedure.image == "some image"
    end

    test "create_procedure/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_procedure(@invalid_attrs)
    end

    test "update_procedure/2 with valid data updates the procedure" do
      procedure = procedure_fixture()
      assert {:ok, %Procedure{} = procedure} = Recipes.update_procedure(procedure, @update_attrs)
      assert procedure.content == "some updated content"
      assert procedure.image == "some updated image"
    end

    test "update_procedure/2 with invalid data returns error changeset" do
      procedure = procedure_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_procedure(procedure, @invalid_attrs)
      assert procedure == Recipes.get_procedure!(procedure.id)
    end

    test "delete_procedure/1 deletes the procedure" do
      procedure = procedure_fixture()
      assert {:ok, %Procedure{}} = Recipes.delete_procedure(procedure)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_procedure!(procedure.id) end
    end

    test "change_procedure/1 returns a procedure changeset" do
      procedure = procedure_fixture()
      assert %Ecto.Changeset{} = Recipes.change_procedure(procedure)
    end
  end

  describe "ingredients" do
    alias RabbitRecipe.Recipes.Ingredients

    @valid_attrs %{amount: "some amount", name: "some name"}
    @update_attrs %{amount: "some updated amount", name: "some updated name"}
    @invalid_attrs %{amount: nil, name: nil}

    def ingredients_fixture(attrs \\ %{}) do
      {:ok, ingredients} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Recipes.create_ingredients()

      ingredients
    end

    test "list_ingredients/0 returns all ingredients" do
      ingredients = ingredients_fixture()
      assert Recipes.list_ingredients() == [ingredients]
    end

    test "get_ingredients!/1 returns the ingredients with given id" do
      ingredients = ingredients_fixture()
      assert Recipes.get_ingredients!(ingredients.id) == ingredients
    end

    test "create_ingredients/1 with valid data creates a ingredients" do
      assert {:ok, %Ingredients{} = ingredients} = Recipes.create_ingredients(@valid_attrs)
      assert ingredients.amount == "some amount"
      assert ingredients.name == "some name"
    end

    test "create_ingredients/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_ingredients(@invalid_attrs)
    end

    test "update_ingredients/2 with valid data updates the ingredients" do
      ingredients = ingredients_fixture()
      assert {:ok, %Ingredients{} = ingredients} = Recipes.update_ingredients(ingredients, @update_attrs)
      assert ingredients.amount == "some updated amount"
      assert ingredients.name == "some updated name"
    end

    test "update_ingredients/2 with invalid data returns error changeset" do
      ingredients = ingredients_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_ingredients(ingredients, @invalid_attrs)
      assert ingredients == Recipes.get_ingredients!(ingredients.id)
    end

    test "delete_ingredients/1 deletes the ingredients" do
      ingredients = ingredients_fixture()
      assert {:ok, %Ingredients{}} = Recipes.delete_ingredients(ingredients)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_ingredients!(ingredients.id) end
    end

    test "change_ingredients/1 returns a ingredients changeset" do
      ingredients = ingredients_fixture()
      assert %Ecto.Changeset{} = Recipes.change_ingredients(ingredients)
    end
  end
end
