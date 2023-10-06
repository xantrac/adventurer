defmodule AdventurerWeb.Schema.Json do
  use Absinthe.Schema.Notation

  @desc "Custom JSON scalar type"

  scalar :json, name: "JSON" do
    parse(&Jason.decode!/1)
    serialize(&Jason.encode!/1)
  end
end
