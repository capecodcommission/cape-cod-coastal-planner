defmodule ChipApiWeb.Schema.Query.ShorelineLocationsTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :shoreline_locations_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    @query """
    {
        shorelineLocations {
            name
        }
    }
    """
    test "shorelineLocations field returns locations", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "shorelineLocations" => [
                    %{"name" => data.cell1.name},
                    %{"name" => data.cell2.name}
                ]
            }
        }
    end

    @query """
    {
        shorelineLocations {
            extent
        }
    }
    """
    test "shorelineLocations field returns locations with extent formatted as [minX, minY, maxX, maxY]", %{data: data} do
        expected_extent = [
            data.cell1.minX, 
            data.cell1.minY, 
            data.cell1.maxX, 
            data.cell1.maxY
        ]
        
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"extent" => expected_extent } | _]
            }
        } = json_response(response, 200)
    end
    
    describe "filtering shorelineLocations by name" do
        @query """
        {
            shorelineLocations(filter: {name: "cell2"}) {
                name
            }
        }
        """
        test "returns matching locations", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "shorelineLocations" => [%{"name" => data.cell2.name}]
                }
            }
        end

        @query """
        {
            shorelineLocations(filter: {name: 123}) {
                name
            }
        }
        """
        test "returns errors when using a bad value" do
            response = get build_conn(), "/api", query: @query
            assert %{"errors" => [
                %{"message" => message}
            ]} = json_response(response, 400)
            assert message == "Argument \"filter\" has invalid value {name: 123}.\nIn field \"name\": Expected type \"String\", found 123."
        end

        @query """
        query ($term: String) {
            shorelineLocations(filter: {name: $term}) {
                name
            }
        }
        """
        @variables %{"term" => "cell2"}
        test "returns matching locations when using a variable", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "shorelineLocations" => [%{"name" => data.cell2.name}]
                }
            }        
        end

        @query """
        query ($term: String) {
            shorelineLocations(filter: {name: $term}) {
                name
            }
        }
        """
        @variables %{"term" => 0}
        test "returns errors when using a bad variable value" do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert %{"errors" => _} = json_response(response, 400)
        end
    end

    describe "sorting shorelineLocations by order (name)" do

        @query """
        {
            shorelineLocations(order:ASC) {
                name
            }
        }
        """
        test "returns locations in ascending order, according to name", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "shorelineLocations" => [
                        %{"name" => data.cell1.name},
                        %{"name" => data.cell2.name}
                    ]
                }
            }
        end

        @query """
        {
            shorelineLocations(order:DESC) {
                name
            }
        }
        """
        test "returns locations in descending order, according to name", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "shorelineLocations" => [
                        %{"name" => data.cell2.name},
                        %{"name" => data.cell1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            shorelineLocations(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns locations in descending order when using variable, according to name", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "shorelineLocations" => [
                        %{"name" => data.cell2.name},
                        %{"name" => data.cell1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            shorelineLocations(order:$term) {
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