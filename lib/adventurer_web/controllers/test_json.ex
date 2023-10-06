defmodule AdventurerWeb.TestJSON do
  alias Adventurer.Tests.Test

  @doc """
  Renders a list of tests.
  """
  def index(%{tests: tests}) do
    %{data: for(test <- tests, do: data(test))}
  end

  @doc """
  Renders a single test.
  """
  def show(%{test: test}) do
    %{data: data(test)}
  end

  defp data(%Test{} = test) do
    %{
      id: test.id
    }
  end
end
