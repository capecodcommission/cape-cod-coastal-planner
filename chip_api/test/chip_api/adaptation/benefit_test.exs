defmodule ChipApi.Adaptation.BenefitTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Adaptation.{Strategies, Benefit}

    @moduletag :adaptation_case
    @moduletag :benefit_case

    setup do
        ChipApi.Fakes.run_benefits()
    end

    test "list_benefits returns all adaptation benefits", %{data: data} do
        benefits = for c <- Strategies.list_benefits(), do: c.name
        assert [data.benefit1.name, data.benefit2.name] == benefits
    end

end