defmodule Tadot.CLI.FallbackController do
  alias Tadot.CLI.Conv

  def intercept(%Conv{} = conv, unhandled_result, original_controller) do
    conv
    |> handle_case(unhandled_result, original_controller)
    |> next(conv)
  end

  def handle_case(_conv, {:error, :spaghetti}, _original_controller) do
    {:error, :delicious_error, "spaghetti"}
  end

  def handle_case(_conv, {:error, _reason} = error, _original_controller) do
    error
  end

  def handle_case(conv, _error, original_controller) do
    conv
    |> elevate_error({:error, :unknown_error}, original_controller)
  end

  defp elevate_error(conv, error, original_controller) do
    conv
    |> Conv.apply_field(:result, error)
    |> Conv.close_with_error(__MODULE__, %{trace: [original_controller]})
  end

  defp next(%Conv{} = conv, _old_conv) do
    conv
  end

  defp next(result, %Conv{} = conv) do
    Conv.apply_field(conv, :result, result)
  end
end
