defmodule Pokedex.Pokemon do
  defstruct [:id, :name, :types]
end

defmodule Pokedex.PokeAPI do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://pokeapi.co/api/v2")
  plug(Tesla.Middleware.JSON)

  def get_pokemon(name) do
    case get("/pokemon/" <> name) do
      {:error, _} -> {:error, "Error"}
      {:ok, %{status: 404}} -> {:error, "NotFound"}
      {:ok, %{status: 200, body: body}} -> {:ok, cast_to_pokemon(body)}
    end
  end

  defp cast_to_pokemon(body) do
    struct(Pokedex.Pokemon, %{
      id: body["id"],
      name: body["name"],
      types: Enum.map(body["types"], &get_in(&1, ["type", "name"]))
    })
  end
end
