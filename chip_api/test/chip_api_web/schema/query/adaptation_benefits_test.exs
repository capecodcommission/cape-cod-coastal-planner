defmodule ChipApiWeb.Schema.Query.AdaptationBenefitsTest do
    use ChipApiWeb.ConnCase, async: true

    @moduletag :adaptation_benefits_case

    setup do
        ChipApi.Fakes.run_benefits()
    end

    @query """
    {
        adaptationBenefits {
            name
        }
    }
    """
    test "adaptationBenefits field returns benefits", %{data: data} do
        response = get build_conn(), "/api", query: @query
        assert json_response(response, 200) == %{
            "data" => %{
                "adaptationBenefits" => [
                    %{"name" => data.benefit1.name},
                    %{"name" => data.benefit2.name}
                ]
            }
        }
    end

    describe "sorting adaptationBenefits by order (when display_order is null for all rows)" do
        
        @query """
        {
            adaptationBenefits(order:ASC) {
                name
            }
        }
        """
        test "returns benefits in ascending order, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationBenefits" => [
                        %{"name" => data.benefit1.name},
                        %{"name" => data.benefit2.name}
                    ]
                }
            }
        end

        @query """
        {
            adaptationBenefits(order:DESC) {
                name
            }
        }
        """
        test "returns benefits in descending order, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationBenefits" => [
                        %{"name" => data.benefit2.name},
                        %{"name" => data.benefit1.name}
                    ]
                }
            }
        end

        @query """
        {
            adaptationBenefits(order:1) {
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
            adaptationBenefits(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "ASC"}
        test "returns benefits in ascending order when using variable, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationBenefits" => [
                        %{"name" => data.benefit1.name},
                        %{"name" => data.benefit2.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            adaptationBenefits(order:$term) {
                name
            }
        }
        """
        @variables %{"term" => "DESC"}
        test "returns benefits in descending order when using variable, according to index", %{data: data} do
            response = get build_conn(), "/api", query: @query, variables: @variables
            assert json_response(response, 200) == %{
                "data" => %{
                    "adaptationBenefits" => [
                        %{"name" => data.benefit2.name},
                        %{"name" => data.benefit1.name}
                    ]
                }
            }
        end

        @query """
        query($term:SortOrder) {
            adaptationBenefits(order:$term) {
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