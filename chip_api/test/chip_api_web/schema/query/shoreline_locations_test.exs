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
                "shorelineLocations" => [ %{"extent" => extent } | _]
            }
        } = json_response(response, 200)
        assert expected_extent == extent
    end

    @query """
    {
        shorelineLocations {
            lengthMiles
        }
    }
    """
    test "shorelineLocations field returns locations with the shoreline length in miles", %{data: data} do
        expected_length = Decimal.to_string data.cell1.length_miles
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"lengthMiles" => length} | _]
            }
        } = json_response(response, 200)
        assert expected_length == length
    end

    @query """
    {
        shorelineLocations {
            impervPercent
        }
    }
    """
    test "shorelineLocations field returns locations with the percentage of impervious surface area", %{data: data} do
        expected_percent = Decimal.to_string data.cell1.imperv_percent
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"impervPercent" => percent} | _]
            }
        } = json_response(response, 200)
        assert expected_percent == percent
    end

    @query """
    {
        shorelineLocations {
            criticalFacilitiesCount
        }
    }
    """
    test "shorelineLocations field returns locations with the count of critical facilities", %{data: data} do
        expected_count = data.cell1.critical_facilities_count
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"criticalFacilitiesCount" => count} | _]
            }
        } = json_response(response, 200)
        assert expected_count == count
    end

    @query """
    {
        shorelineLocations {
            coastalStructuresCount
        }
    }
    """
    test "shorelineLocations field returns locations with the count of coastal structures", %{data: data} do
        expected_count = data.cell1.coastal_structures_count
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"coastalStructuresCount" => count} | _]
            }
        } = json_response(response, 200)
        assert expected_count == count
    end

    @query """
    {
        shorelineLocations {
            workingHarbor
        }
    }
    """
    test "shorelineLocations field returns locations with whether or not there is a working harbor", %{data: data} do
        expected_has_harbor? = data.cell1.working_harbor
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"workingHarbor" => has_harbor?} | _]
            }
        } = json_response(response, 200)
        assert expected_has_harbor? == has_harbor?
    end

    @query """
    {
        shorelineLocations {
            publicBuildingsCount
        }
    }
    """
    test "shorelineLocations field returns locations with count of public buildings", %{data: data} do
        expected_count = data.cell1.public_buildings_count
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"publicBuildingsCount" => count} | _]
            }
        } = json_response(response, 200)
        assert expected_count == count
    end

    @query """
    {
        shorelineLocations {
            saltMarshAcres
        }
    }
    """
    test "shorelineLocations field returns locations with acreage of salt marsh", %{data: data} do
        expected_acres = Decimal.to_string data.cell1.salt_marsh_acres
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"saltMarshAcres" => acres} | _]
            }
        } = json_response(response, 200)
        assert expected_acres == acres
    end

    @query """
    {
        shorelineLocations {
            eelgrassAcres
        }
    }
    """
    test "shorelineLocations field returns locations with acreage of eelgrass", %{data: data} do
        expected_acres = Decimal.to_string data.cell1.eelgrass_acres
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"eelgrassAcres" => acres} | _]
            }
        } = json_response(response, 200)
        assert expected_acres == acres
    end

    @query """
    {
        shorelineLocations {
            publicBeachCount
        }
    }
    """
    test "shorelineLocations field returns locations with count of public beaches", %{data: data} do
        expected_count = data.cell1.public_beach_count
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"publicBeachCount" => count} | _]
            }
        } = json_response(response, 200)
        assert expected_count == count
    end

    @query """
    {
        shorelineLocations {
            recreationOpenSpaceAcres
        }
    }
    """
    test "shorelineLocations field returns locations with acreage of recreational open space", %{data: data} do
        expected_acres = Decimal.to_string data.cell1.recreation_open_space_acres
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"recreationOpenSpaceAcres" => acres} | _]
            }
        } = json_response(response, 200)
        assert expected_acres == acres
    end

    @query """
    {
        shorelineLocations {
            townWaysToWater
        }
    }
    """
    test "shorelineLocations field returns locations with count of town ways to water", %{data: data} do
        expected_count = data.cell1.town_ways_to_water
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"townWaysToWater" => count} | _]
            }
        } = json_response(response, 200)
        assert expected_count == count
    end

    @query """
    {
        shorelineLocations {
            totalAssessedValue
        }
    }
    """
    test "shorelineLocations field returns locations with total assessed value", %{data: data} do
        expected_value = Decimal.to_string data.cell1.total_assessed_value
        response = get build_conn(), "/api", query: @query
        assert %{
            "data" => %{
                "shorelineLocations" => [ %{"totalAssessedValue" => value} | _]
            }
        } = json_response(response, 200)
        assert expected_value == value
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