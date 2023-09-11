defmodule Adventurer.Choices do
  def target_node(choice) do
    [choice_target] = choice.choice_targets
    choice_target.target_node
  end
end
