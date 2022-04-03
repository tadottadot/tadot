defmodule Tadot.CLI.MainController do
  alias Tadot.CLI.Conv
  alias Tadot.CLI.FallbackController

  def run(%Conv{valid?: true, stage: :delegated} = conv) do
    apply(__MODULE__, conv.runnable.action, [conv, conv.runnable.params])
    |> next(conv, fallback: FallbackController)
  end

  def version(_conv, _params) do
    IO.inspect(Tadot.version())

    {:ok, 200}
  end

  def spaghetti(_conv, _params) do
    IO.puts("Simulates error :spaghetti")

    {:error, :spaghetti}
  end

  defp next(%Conv{} = conv, _old_conv, _opts) do
    conv
  end

  defp next({:ok, _status} = result, %Conv{} = conv, _opts) do
    conv
    |> Conv.apply_field(:result, result)
  end

  defp next({:ok, _status, _msg} = result, %Conv{} = conv, _opts) do
    conv
    |> Conv.apply_field(:result, result)
  end

  defp next(unhandled_result, %Conv{} = conv, fallback: fallback_controller) do
    fallback_controller.intercept(conv, unhandled_result, __MODULE__)
  end
end
