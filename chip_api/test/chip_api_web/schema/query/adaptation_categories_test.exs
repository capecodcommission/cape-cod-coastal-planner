defmodule ChipApiWeb.Schema.Query.AdaptationCategoriesTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :api_case
    @moduletag :adaptation_categories_case

    setup do
        ChipApi.Fakes.run_categories()
    end

    @query """
    {
        adaptationCategories {
            name
        }
    }
    """
    test "adaptationCategories field returns categories", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationCategories" => [
                    %{"name" => data.cat1.name},
                    %{"name" => data.cat2.name}
                ]
            }
        }
    end

    describe "sorting adaptationCategories by order (when display_order is null for all rows)" do
        
        @query """
        {
            adaptationCategories(order:ASC) {
                name
            }
        }
        """
        test "returns categories in ascending order, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationCategories" => [
                        %{"name" => data.cat1.name},
                        %{"name" => data.cat2.name}
                    ]
                }
            }
        end

        @query """
        {
            adaptationCategories(order:DESC) {
                name
            }
        }
        """
        test "returns categories in descending order, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationCategories" => [
                        %{"name" => data.cat2.name},
                        %{"name" => data.cat1.name}
                    ]
                }
            }
        end

        @query """
        {
            adaptationCategories(order:1) {
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
            adaptationCategories(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns categories in ascending order when using variable, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationCategories" => [
                        %{"name" => data.cat1.name},
                        %{"name" => data.cat2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            adaptationCategories(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns categories in descending order when using variable, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationCategories" => [
                        %{"name" => data.cat2.name},
                        %{"name" => data.cat1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            adaptationCategories(order:$term) {
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