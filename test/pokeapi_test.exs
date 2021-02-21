defmodule Pokedex.PokeAPITest do
  use ExUnit.Case
  import Tesla.Mock

  test "get pokemon and cast to Pokemon struct" do
    mock(fn
      %{method: :get, url: "https://pokeapi.co/api/v2/pokemon/test"} ->
        json(%{id: 1, name: "test", types: [%{type: %{name: "normal"}}]})
    end)

    assert {:ok, %Pokedex.Pokemon{} = pokemon} = Pokedex.PokeAPI.get_pokemon("test")
    assert pokemon == %Pokedex.Pokemon{id: 1, name: "test", types: ["normal"]}
  end

  test "not found" do
    mock(fn
      %{method: :get, url: "https://pokeapi.co/api/v2/pokemon/test"} ->
        %Tesla.Env{status: 404}
    end)

    assert {:error, "NotFound"} = Pokedex.PokeAPI.get_pokemon("test")
  end

  test "request error" do
    mock(fn
      %{method: :get, url: "https://pokeapi.co/api/v2/pokemon/test"} ->
        {:error}
    end)

    assert {:error, "Error"} = Pokedex.PokeAPI.get_pokemon("test")
  end
end
