defmodule ChipApiWeb.Schema.Query.ImpactScalesTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :impact_scales_case

    setup do
        ChipApi.Fakes.run_scales()
    end

    @query """
    {
        impactScales {
            name
        }
    }
    """
    test "impactScales field returns scales", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "impactScales" => [
                    %{"name" => data.scale1.name},
                    %{"name" => data.scale3.name},
                    %{"name" => data.scale2.name}
                ]
            }
        }
    end

    describe "sorting impactScales by order (when at least one display_order is null)" do
        
        @query """
        {
            impactScales(order:ASC) {
                name
            }
        }
        """
        test "returns scales in ascending order, according to display_order but nulls last", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactScales" => [
                        %{"name" => data.scale1.name},
                        %{"name" => data.scale3.name},
                        %{"name" => data.scale2.name}
                    ]
                }
            }
        end

        @query """
        {
            impactScales(order:DESC) {
                name
            }
        }
        """
        test "returns scales in descending order, according to display_order but nulls first", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactScales" => [
                        %{"name" => data.scale2.name},
                        %{"name" => data.scale3.name},
                        %{"name" => data.scale1.name}
                    ]
                }
            }
        end

        @query """
        {
            impactScales(order:1) {
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
            impactScales(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns scales in ascending order when using variable, according to display_order but nulls last", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactScales" => [
                        %{"name" => data.scale1.name},
                        %{"name" => data.scale3.name},
                        %{"name" => data.scale2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            impactScales(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns scales in descending order when using variable, according to display_order but nulls first", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "impactScales" => [
                        %{"name" => data.scale2.name},
                        %{"name" => data.scale3.name},
                        %{"name" => data.scale1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            impactScales(order:$term) {
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