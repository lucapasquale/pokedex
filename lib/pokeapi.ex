defmodule Pokedex.PokeAPI do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://pokeapi.co/api/v2")
  plug(Tesla.Middleware.JSON)

  def get_pokemon(name) do
    case get("/pokemon/" <> name) do
      {:error} -> {:error, "Error"}
      {:ok, %{status: 404}} -> {:error, "NotFound"}
      {:ok, %{status: 200, body: body}} -> {:ok, cast_to_pokemon(body)}
    end
  end

  defp cast_to_pokemon(pokemon_map) do
    atom_map = for {key, val} <- pokemon_map, into: %{}, do: {String.to_atom(key), val}
    struct(Pokedex.Pokemon, atom_map)
  end
end
