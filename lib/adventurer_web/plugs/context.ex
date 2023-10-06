defmodule AdventurerWeb.Context do
  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(%{assigns: %{current_user: %Adventurer.Accounts.User{} = current_user}}) do
    %{current_user: current_user}
  end

  defp build_context(%{assigns: %{current_user: _}}) do
    %{}
  end
end
