defmodule Adventurer.Choices do
  def target_node(choice) do
    case choice.choice_targets do
      [] -> nil
      [choice_target] -> choice_target.target_node
    end
  end
end
