defmodule ChipApiWeb.Schema.Query.CoastalHazardsTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :coastal_hazards_case

    setup do
        ChipApi.Fakes.run_hazards()
    end

    @query """
    {
        coastalHazards {
            name
        }
    }
    """
    test "coastalHazards field returns hazards", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "coastalHazards" => [
                    %{"name" => data.haz2.name},
                    %{"name" => data.haz1.name}
                ]
            }
        }
    end

    describe "sorting coastalHazards by order (when display_order is set in reverse)" do
        
        @query """
        {
            coastalHazards(order:ASC) {
                name
            }
        }
        """
        test "returns hazards in ascending order, according to display_order", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "coastalHazards" => [
                        %{"name" => data.haz2.name},
                        %{"name" => data.haz1.name}
                    ]
                }
            }
        end

        @query """
        {
            coastalHazards(order:DESC) {
                name
            }
        }
        """
        test "returns hazards in descending order, according to display_order", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "coastalHazards" => [
                        %{"name" => data.haz1.name},
                        %{"name" => data.haz2.name}
                    ]
                }
            }
        end

        @query """
        {
            coastalHazards(order:1) {
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
            coastalHazards(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns hazards in ascending order when using variable, according to display_order", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "coastalHazards" => [
                        %{"name" => data.haz2.name},
                        %{"name" => data.haz1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            coastalHazards(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns hazards in descending order when using variable, according to display_order", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "coastalHazards" => [
                        %{"name" => data.haz1.name},
                        %{"name" => data.haz2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            coastalHazards(order:$term) {
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