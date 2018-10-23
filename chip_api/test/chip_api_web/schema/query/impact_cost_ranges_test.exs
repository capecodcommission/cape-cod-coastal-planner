defmodule ChipApiWeb.Schema.Query.ImpactCostRangesTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :impact_cost_ranges_case

    setup do
        ChipApi.Fakes.run_cost_ranges()
    end

    @query """
    {
        impactCostRanges {
            name
        }
    }
    """
    test "impactCostRanges field returns cost ranges", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "impactCostRanges" => [
                    %{"name" => data.costrange1.name},
                    %{"name" => data.costrange3.name},
                    %{"name" => data.costrange4.name},
                    %{"name" => data.costrange2.name}
                ]
            }
        }
    end

    describe "sorting impactCostRanges by order (when at least one display_order is null)" do
        
        @query """
        {
            impactCostRanges(order:ASC) {
                name
            }
        }
        """
        test "returns cost ranges in ascending order, according to display_order but nulls last", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactCostRanges" => [
                        %{"name" => data.costrange1.name},
                        %{"name" => data.costrange3.name},
                        %{"name" => data.costrange4.name},
                        %{"name" => data.costrange2.name}
                    ]
                }
            }
        end

        @query """
        {
            impactCostRanges(order:DESC) {
                name
            }
        }
        """
        test "returns cost ranges in descending order, according to display_order but nulls first", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactCostRanges" => [
                        %{"name" => data.costrange2.name},
                        %{"name" => data.costrange4.name},
                        %{"name" => data.costrange3.name},
                        %{"name" => data.costrange1.name}
                    ]
                }
            }
        end

        @query """
        {
            impactCostRanges(order:1) {
                name
            }
        }
        """
        test "returns errors when using bad value" do
            response = get build_conn(), "/api", query: @query
            assert %{"errors" => [
                %{"message" => message}
            ]} = json_response(response, 400)
            assert message == "Argument \"order\" has invalid value 1."
        end

        @query """
        query($term:SortOrder) {
            impactCostRanges(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns cost ranges in ascending order when using variable, according to display_order but nulls last", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactCostRanges" => [
                        %{"name" => data.costrange1.name},
                        %{"name" => data.costrange3.name},
                        %{"name" => data.costrange4.name},
                        %{"name" => data.costrange2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            impactCostRanges(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns cost ranges in descending order when using variable, according to display_order but nulls first", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactCostRanges" => [
                        %{"name" => data.costrange2.name},
                        %{"name" => data.costrange4.name},
                        %{"name" => data.costrange3.name},
                        %{"name" => data.costrange1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            impactCostRanges(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => 1}
        test "returns errors when using bad value variable" do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert %{"errors" => _} = json_response(response, 400)
        end
    end
end