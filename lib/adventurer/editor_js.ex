defmodule Adventurer.EditorJs do
  def blocks_to_html(%{"blocks" => blocks}) do
    blocks
    |> Enum.map(&block_to_html/1)
    |> Enum.join("\n")
  end

  defp block_to_html(%{"data" => %{"text" => text}, "type" => "paragraph"}) do
    "<p>#{text}</p>"
  end
end
