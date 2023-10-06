defmodule Adventurer.TestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Adventurer.Tests` context.
  """

  @doc """
  Generate a test.
  """
  def test_fixture(attrs \\ %{}) do
    {:ok, test} =
      attrs
      |> Enum.into(%{

      })
      |> Adventurer.Tests.create_test()

    test
  end
end
