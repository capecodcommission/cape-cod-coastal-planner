defmodule ChipApiWeb.Schema.Query.Sync.AdaptationStrategiesTest do
    @moduledoc """
    This module runs in synchronous mode for dealing with queries that
    try to hit the cache before falling back to the repo.

    There is likely a much better way to organize these, but this is OK
    for the time being.

    Below this module is one that runs tests in asynchronous mode for the
    remainder of tests that do not rely on a cache query.
    """
    use ChipApiWeb.ConnCase

    @moduletag :adaptation_strategies_case

    setup do
        ChipApi.Fakes.run_all_adaptation()
    end

    test "adaptationStrategy feild returns a location when using a good id", %{data: data} do
        query = """
        {
            adaptationStrategy(id: #{data.strat1.id}) {
                id
            }
        }
        """
        response = get build_conn(), "/api", query: query
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationStrategy" => %{"id" => to_string data.strat1.id}
            }
        }
    end

    test "adaptationStrategy field returns nil when using a bad id" do
        query = """
        {
            adaptationStrategy(id: -12) {
                id
            }
        }
        """
        response = get build_conn(), "/api", query: query
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationStrategy" => nil
            }
        }
    end
end



defmodule ChipApiWeb.Schema.Query.Async.AdaptationStrategiesTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :adaptation_strategies_case

    setup do
        ChipApi.Fakes.run_all_adaptation()
    end

    @query """
    {
        adaptationStrategies {
            name
        }
    }
    """
    test "adaptationStrategies field returns strategies", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationStrategies" => [
                    %{"name" => data.strat1.name},
                    %{"name" => data.strat2.name}
                ]}
        }
    end

    describe "filtering adaptationStrategies by name" do
        @query """
        {
            adaptationStrategies(filter: {name: "strat2"}) {
                name
            }
        }
        """
        test "returns matching strategies", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [%{"name" => data.strat2.name}]
                }
            }
        end

        @query """
        {
            adaptationStrategies(filter: {name: 123}) {
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
            adaptationStrategies(filter: {name: $term}) {
                name
            }
        }
        """
        @variables %{"term" => "strat2"}
        test "returns matching strategies when using a variable", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [%{"name" => data.strat2.name}]
                }
            }        
        end

        @query """
        query ($term: String) {
            adaptationStrategies(filter: {name: $term}) {
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

    describe "filtering adaptationStrategies by isActive" do
        @query """
        {
            adaptationStrategies(filter: {isActive: true}) {
                name
            }
        }
        """
        test "returns active strategies when true", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [%{"name" => data.strat1.name}]
                }
            }
        end

        @query """
        {
            adaptationStrategies(filter: {isActive: false}) {
                name
            }
        }
        """
        test "returns inactive strategies when false", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [%{"name" => data.strat2.name}]
                }
            }
        end

        @query """
        {
            adaptationStrategies(filter: {isActive: 123}) {
                name
            }
        }
        """
        test "returns errors when using a bad value" do
            response = get build_conn(), "/api", query: @query
            assert %{"errors" => [
                %{"message" => message}
            ]} = json_response(response, 400)
            assert message == "Argument \"filter\" has invalid value {isActive: 123}.\nIn field \"isActive\": Expected type \"Boolean\", found 123."
        end

        @query """
        query ($term: Boolean) {
            adaptationStrategies(filter: {isActive: $term}) {
                name
            }
        }
        """
        @variables %{"term" => true}
        test "returns active strategies when true and using a variable", %{data: data} do
        response = get build_conn(), "/api", query: @query, variables: @variables
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationStrategies" => [%{"name" => data.strat1.name}]
            }
        }        
        end

        @query """
        query ($term: Boolean) {
            adaptationStrategies(filter: {isActive: $term}) {
                name
            }
        }
        """
        @variables %{"term" => false}
        test "returns inactive strategies when false and using a variable", %{data: data} do
        response = get build_conn(), "/api", query: @query, variables: @variables
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationStrategies" => [%{"name" => data.strat2.name}]
            }
        }        
        end

        @query """
        query ($term: Boolean) {
            adaptationStrategies(filter: {isActive: $term}) {
                name
            }
        }
        """
        @variables %{"term" => 123}
        test "returns errors when using bad value variable" do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert %{"errors" => _} = json_response(response, 400)
        end
    end

    describe "sorting adaptationStrategies by order" do
        
        @query """
        {
            adaptationStrategies(order:ASC) {
                name
            }
        }
        """
        test "returns strategies in ascending order", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [
                        %{"name" => data.strat1.name},
                        %{"name" => data.strat2.name}
                    ]
                }
            }
        end

        @query """
        {
            adaptationStrategies(order:DESC) {
                name
            }
        }
        """
        test "returns strategies in descending order", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [
                        %{"name" => data.strat2.name},
                        %{"name" => data.strat1.name}
                    ]
                }
            }
        end

        @query """
        {
            adaptationStrategies(order:1) {
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
            adaptationStrategies(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns strategies in ascending order when using variable", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [
                        %{"name" => data.strat1.name},
                        %{"name" => data.strat2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            adaptationStrategies(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns strategies in descending order when using variable", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationStrategies" => [
                        %{"name" => data.strat2.name},
                        %{"name" => data.strat1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            adaptationStrategies(order:$term) {
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