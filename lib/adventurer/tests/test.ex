defmodule Adventurer.Tests.Test do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tests" do


    timestamps()
  end

  @doc false
  def changeset(test, attrs) do
    test
    |> cast(attrs, [])
    |> validate_required([])
  end
end
