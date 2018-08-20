defmodule ChipApiWeb.Schema.Query.StrategyPlacementsTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :strategy_placements_case

    setup do
        ChipApi.Fakes.run_placements()
    end

    @query """
    {
        placements {
            name
        }
    }
    """
    test "placements field returns placements", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "placements" => [
                    %{"name" => data.place1.name},
                    %{"name" => data.place2.name}
                ]
            }
        }
    end
end