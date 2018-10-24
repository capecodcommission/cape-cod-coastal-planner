defmodule ChipApiWeb.Schema.Query.ImpactLifeSpanRangesTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :impact_life_span_ranges_case

    setup do
        ChipApi.Fakes.run_life_span_ranges()
    end

    @query """
    {
        impactLifeSpans {
            name
        }
    }
    """
    test "impactLifeSpans field returns life span ranges", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "impactLifeSpans" => [
                    %{"name" => data.lifespanrange1.name},
                    %{"name" => data.lifespanrange3.name},
                    %{"name" => data.lifespanrange4.name},
                    %{"name" => data.lifespanrange2.name}
                ]
            }
        }
    end

    describe "sorting impactLifeSpans by order (when at least one display_order is null)" do
        
        @query """
        {
            impactLifeSpans(order:ASC) {
                name
            }
        }
        """
        test "returns life span ranges in ascending order, according to display_order but nulls last", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactLifeSpans" => [
                        %{"name" => data.lifespanrange1.name},
                        %{"name" => data.lifespanrange3.name},
                        %{"name" => data.lifespanrange4.name},
                        %{"name" => data.lifespanrange2.name}
                    ]
                }
            }
        end

        @query """
        {
            impactLifeSpans(order:DESC) {
                name
            }
        }
        """
        test "returns life span ranges in descending order, according to display_order but nulls first", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactLifeSpans" => [
                        %{"name" => data.lifespanrange2.name},
                        %{"name" => data.lifespanrange4.name},
                        %{"name" => data.lifespanrange3.name},
                        %{"name" => data.lifespanrange1.name}
                    ]
                }
            }
        end

        @query """
        {
            impactLifeSpans(order:1) {
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
            impactLifeSpans(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns life span ranges in ascending order when using variable, according to display_order but nulls last", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactLifeSpans" => [
                        %{"name" => data.lifespanrange1.name},
                        %{"name" => data.lifespanrange3.name},
                        %{"name" => data.lifespanrange4.name},
                        %{"name" => data.lifespanrange2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            impactLifeSpans(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns life span ranges in descending order when using variable, according to display_order but nulls first", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactLifeSpans" => [
                        %{"name" => data.lifespanrange2.name},
                        %{"name" => data.lifespanrange4.name},
                        %{"name" => data.lifespanrange3.name},
                        %{"name" => data.lifespanrange1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            impactLifeSpans(order:$term) {
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