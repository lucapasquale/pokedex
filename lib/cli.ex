defmodule Pokedex.CLI do
  def main(args) do
    args
    |> Enum.map(&cleanup_arg/1)
    |> execute_command
  end

  defp cleanup_arg(arg) do
    arg
    |> String.trim()
    |> String.downcase()
  end

  defp execute_command(["pokemon", name]) do
    case Pokedex.PokeAPI.get_pokemon(name) do
      {:error, error} -> IO.puts("Error trying to find pokemon #{name}: #{error}")
      {:ok, pokemon} -> IO.inspect(pokemon)
    end
  end

  defp execute_command([]) do
    IO.puts("Please provide a command")
    list_of_commands()
  end

  defp execute_command(_unknown) do
    IO.puts("Invalid command. I don't know what to do.")
    list_of_commands()
  end

  @commands %{
    "pokemon <name>" => "Searches a Pokemon by name"
  }

  defp list_of_commands() do
    IO.puts("Available commands:\n")

    @commands
    |> Enum.map(fn {command, description} -> IO.puts("  #{command} - #{description}") end)
  end
end
