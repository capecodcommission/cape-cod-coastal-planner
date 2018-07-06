defmodule ChipApiWeb.Schema.Query.StrategiesTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :strategies_case

    setup do
        ChipApi.Fakes.run_all()
    end

    @query """
    {
        adaptationStrategies {
            name
        }
    }
    """
    test "adaptationStrategies field returns strategies", %{data: data} do
        conn = get build_conn(), "/api", query: @query
        assert json_response(conn, 200) == %{
            "data" => 
                %{"adaptationStrategies" => [
                    %{"name" => data.strat1.name},
                    %{"name" => data.strat2.name}
                ]}
        }
    end
end