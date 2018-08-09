defmodule ChipApi.Geospatial.LittoralCell.UpdateLittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.{ShorelineLocations, LittoralCell}
    alias Decimal, as: D

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case
    @moduletag :update_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

    @attrs %{
        name: "test",
        min_x: -50.0,
        min_y: 50.0,
        max_x: 50.0,
        max_y: 50.0,
        length_miles: D.new("11.11"),
        imperv_percent: D.new("22.22"),
        critical_facilities_count: 1,
        coastal_structures_count: 2,
        working_harbor: true,
        public_buildings_count: 3,
        salt_marsh_acres: D.new("33.33"),
        eelgrass_acres: D.new("44.44"),
        public_beach_count: 4,
        recreation_open_space_acres: D.new("55.55"),
        town_ways_to_water: 5,
        total_assessed_value: D.new("66.66")
    }
    describe "update_littoral_cell/1" do
        test "with good values returns an updated littoral cell", %{data: data} do
            parent = self()
            task = Task.async(fn ->
                allow(parent, self())
                ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            end)

            assert {:ok, cell} = Task.await(task)
            assert @attrs ==
                Repo.get!(LittoralCell, cell.id)
                |> Map.take([
                    :name, :min_x, :min_y, :max_x, :max_y, :length_miles,
                    :imperv_percent, :critical_facilities_count, :coastal_structures_count,
                    :working_harbor, :public_buildings_count, :salt_marsh_acres,
                    :eelgrass_acres, :public_beach_count, :recreation_open_space_acres,
                    :town_ways_to_water, :total_assessed_value
                ])
        end

        test "without a blank name value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{name: nil})
            assert "can't be blank" in errors_on(changeset).name
        end

        test "without a blank min_x value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{min_x: nil})
            assert "can't be blank" in errors_on(changeset).min_x
        end

        test "without a blank min_y value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{min_y: nil})
            assert "can't be blank" in errors_on(changeset).min_y
        end

        test "without a blank max_x value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{max_x: nil})
            assert "can't be blank" in errors_on(changeset).max_x
        end

        test "without a blank max_y value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{max_y: nil})
            assert "can't be blank" in errors_on(changeset).max_y
        end

        test "with a duplicate name returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, %{name: data.cell2.name})
            assert "has already been taken" in errors_on(changeset).name
        end

        @attrs %{name: 5}
        test "with a bad name value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).name
        end

        @attrs %{min_x: "bad"}
        test "with a bad min_x value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).min_x
        end
        
        @attrs %{min_y: "bad"}
        test "with a bad min_y value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).min_y
        end
        
        @attrs %{max_x: "bad"}
        test "with a bad max_x value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).max_x
        end
        
        @attrs %{max_y: "bad"}
        test "with a bad max_y value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).max_y
        end

        @attrs %{length_miles: "bad"}
        test "with a bad length_miles value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).length_miles
        end

        @attrs %{imperv_percent: "bad"}
        test "with a bad imperv_percent value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).imperv_percent
        end

        @attrs %{critical_facilities_count: "bad"}
        test "with a bad critical_facilities_count value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).critical_facilities_count
        end

        @attrs %{coastal_structures_count: "bad"}
        test "with a bad coastal_structures_count value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).coastal_structures_count
        end

        @attrs %{working_harbor: "bad"}
        test "with a bad working_harbor value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).working_harbor
        end

        @attrs %{public_buildings_count: "bad"}
        test "with a bad public_buildings_count value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).public_buildings_count
        end

        @attrs %{salt_marsh_acres: "bad"}
        test "with a bad salt_marsh_acres value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).salt_marsh_acres
        end

        @attrs %{eelgrass_acres: "bad"}
        test "with a bad eelgrass_acres value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).eelgrass_acres
        end

        @attrs %{public_beach_count: "bad"}
        test "with a bad public_beach_count value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).public_beach_count
        end

        @attrs %{recreation_open_space_acres: "bad"}
        test "with a bad recreation_open_space_acres value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).recreation_open_space_acres
        end

        @attrs %{town_ways_to_water: "bad"}
        test "with a bad town_ways_to_water value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).town_ways_to_water
        end

        @attrs %{total_assessed_value: "bad"}
        test "with a bad total_assessed_value value returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "is invalid" in errors_on(changeset).total_assessed_value
        end

        @attrs %{min_x: 181.0}
        test "with min_x value greater than 180.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be less than or equal to 180.0" in errors_on(changeset).min_x
        end

        @attrs %{min_x: -181.0}
        test "with min_x value less than -180.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to -180.0" in errors_on(changeset).min_x
        end

        @attrs %{min_y: 91.0}
        test "with min_y value greater than 90.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be less than or equal to 90.0" in errors_on(changeset).min_y
        end

        @attrs %{min_y: -91.0}
        test "with min_y value less than -90.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to -90.0" in errors_on(changeset).min_y
        end

        @attrs %{max_x: 181.0}
        test "with max_x value greater than 180.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be less than or equal to 180.0" in errors_on(changeset).max_x
        end

        @attrs %{max_x: -181.0}
        test "with max_x value less than -180.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to -180.0" in errors_on(changeset).max_x
        end

        @attrs %{max_y: 91.0}
        test "with max_y value greater than 90.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be less than or equal to 90.0" in errors_on(changeset).max_y
        end

        @attrs %{max_y: -91.0}
        test "with max_y value less than -90.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to -90.0" in errors_on(changeset).max_y
        end

        @attrs %{length_miles: D.new("-0.1")}
        test "with length_miles value less than 0.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).length_miles
        end

        @attrs %{imperv_percent: D.new("100.1")}
        test "with imperv_percent value greater than 100.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be greater than 100.0" in errors_on(changeset).imperv_percent
        end

        @attrs %{imperv_percent: D.new("-0.1")}
        test "with imperv_percent value less than 0.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).imperv_percent
        end

        @attrs %{critical_facilities_count: -1}
        test "with critical_facilities_count value less than 0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).critical_facilities_count
        end

        @attrs %{coastal_structures_count: -1}
        test "with coastal_structures_count value less than 0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).coastal_structures_count
        end

        @attrs %{public_buildings_count: -1}
        test "with public_buildings_count value less than 0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).public_buildings_count
        end

        @attrs %{salt_marsh_acres: D.new("-0.1")}
        test "with salt_marsh_acres value less than 0.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).salt_marsh_acres
        end

        @attrs %{eelgrass_acres: D.new("-0.1")}
        test "with eelgrass_acres value less than 0.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).eelgrass_acres
        end

        @attrs %{public_beach_count: -1}
        test "with public_beach_count value less than 0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).public_beach_count
        end

        @attrs %{recreation_open_space_acres: D.new("-0.1")}
        test "with recreation_open_space_acres value less than 0.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).recreation_open_space_acres
        end

        @attrs %{town_ways_to_water: -1}
        test "with town_ways_to_water value less than 0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).town_ways_to_water
        end

        @attrs %{total_assessed_value: D.new("-0.1")}
        test "with total_assessed_value value less than 0.0 returns error and changeset", %{data: data} do
            assert {:error, changeset} = ShorelineLocations.update_littoral_cell(data.cell1, @attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).total_assessed_value
        end
    end

end