defmodule ChipApiWeb.Schema.Query.ShorelineLocationsTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :shoreline_locations_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    test "shorelineLocation field returns a location when using a good id", %{data: data} do
        query = """
        {
            shorelineLocation(id: #{data.cell1.id}) {
                id
            }
        }
        """
        response = get build_conn(), "/api", query: query
        assert json_response(response, 200) == %{
            "data" => %{
                "shorelineLocation" => %{"id" => to_string data.cell1.id}
            }
        }
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
    test "shorelineLocations field returns locations with extent formatted as [min_x, min_y, max_x, max_y]", %{data: data} do
        expected_extent = [
            data.cell1.min_x, 
            data.cell1.min_y, 
            data.cell1.max_x, 
            data.cell1.max_y
        ]
        
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"extent" => expected_extent } | _]
            }
        } = json_response(response, 200)
    end

    @query """
    {
        shorelineLocations {
            lengthMiles
        }
    }
    """
    test "shorelineLocations field returns locations with the shoreline length in miles", %{data: data} do
        len = Decimal.to_string data.cell1.length_miles
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"lengthMiles" => len} | _]
            }
        } = json_response(response, 200)
    end

    @query """
    {
        shorelineLocations {
            impervPercent
        }
    }
    """
    test "shorelineLocations field returns locations with the percentage of impervious surface area", %{data: data} do
        perc = Decimal.to_string data.cell1.imperv_percent
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"impervPercent" => perc} | _]
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