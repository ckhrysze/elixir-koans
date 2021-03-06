defmodule Tracker do
  def start(modules) do
    total = modules
            |> Enum.flat_map(&(&1.all_koans))
            |> Enum.count

    Agent.start_link(fn -> {total, MapSet.new()} end, name: __MODULE__)
    modules
  end

  def get do
    Agent.get(__MODULE__, &(&1))
    |> summarize
  end

  def completed(koan) do
    Agent.update(__MODULE__, fn({total, completed}) ->
      {total, MapSet.put(completed, koan)}
    end)
  end

  def summarize({total, completed}) do
    %{total: total, current: MapSet.size(completed)}
  end
end
