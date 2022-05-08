defmodule Tadot.CLI.Utils do
  @moduledoc """
  Utility functions to interact with the OS
  """

  def browse(%{url: url}), do: open(url)
  def browse(_), do: :ok

  defp open(url), do: Porcelain.spawn_shell("#{open_cmd()} #{url} 2>/dev/null &")

  defp open_cmd do
    case :os.type() do
      {:unix, :linux} -> "xdg-open"
      {:unix, :darwin} -> "open"
      _ -> "start"
    end
  end
end
