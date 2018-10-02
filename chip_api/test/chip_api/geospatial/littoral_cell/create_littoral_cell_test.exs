defmodule ChipApi.Geospatial.LittoralCell.CreateLittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.{ShorelineLocations, LittoralCell}
    alias Decimal, as: D

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case
    @moduletag :create_case

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
        total_assessed_value: D.new("66.66"),
        littoral_cell_id: 4
    }
    
    describe "create_littoral_cell/1" do
        test "with good values creates a new littoral cell" do
            parent = self()
            task = Task.async(fn ->
                allow(parent, self())
                ShorelineLocations.create_littoral_cell(@attrs)
            end)

            assert {:ok, cell} = Task.await(task)
            assert @attrs ==
                Repo.get!(LittoralCell, cell.id)                
                |> Map.take([
                    :name, :min_x, :min_y, :max_x, :max_y, :length_miles,
                    :imperv_percent, :critical_facilities_count, :coastal_structures_count,
                    :working_harbor, :public_buildings_count, :salt_marsh_acres,
                    :eelgrass_acres, :public_beach_count, :recreation_open_space_acres,
                    :town_ways_to_water, :total_assessed_value, :littoral_cell_id
                ])
                
        end

        test "with duplicate name returns error and changeset", %{data: data} do
            attrs = @attrs |> Map.replace!(:name, data.cell1.name)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "has already been taken" in errors_on(changeset).name
        end

        test "without required fields returns errors and changeset" do
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(%{})
            
            error_text = "can't be blank"
            errors = errors_on(changeset)

            assert 6 = errors |> Map.keys() |> length()
            assert error_text in errors.name
            assert error_text in errors.min_x
            assert error_text in errors.min_y
            assert error_text in errors.max_x
            assert error_text in errors.max_y
            assert error_text in errors.littoral_cell_id
        end

        test "name field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:name, 12)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).name
        end

        test "min_x field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:min_x, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).min_x
        end

        test "min_y field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:min_y, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).min_y
        end

        test "max_x field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:max_x, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).max_x
        end

        test "max_y field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:max_y, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).max_y
        end

        test "length_miles field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:length_miles, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).length_miles
        end

        test "imperv_percent field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:imperv_percent, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).imperv_percent
        end

        test "critical_facilities_count field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:critical_facilities_count, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).critical_facilities_count
        end

        test "coastal_structures_count field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:coastal_structures_count, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).coastal_structures_count
        end

        test "working_harbor field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:working_harbor, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).working_harbor
        end

        test "public_buildings_count field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:public_buildings_count, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).public_buildings_count
        end

        test "salt_marsh_acres field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:salt_marsh_acres, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).salt_marsh_acres
        end

        test "eelgrass_acres field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:eelgrass_acres, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).eelgrass_acres
        end

        test "public_beach_count field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:public_beach_count, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).public_beach_count
        end

        test "recreation_open_space_acres field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:recreation_open_space_acres, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).recreation_open_space_acres
        end

        test "town_ways_to_water field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:town_ways_to_water, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).town_ways_to_water
        end

        test "total_assessed_value field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:total_assessed_value, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).total_assessed_value
        end

        test "littoral_cell_id field with bad value types returns error and changeset" do
            attrs = @attrs |> Map.replace!(:littoral_cell_id, "bad")
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "is invalid" in errors_on(changeset).littoral_cell_id
        end

        test "with min_x value greater than 180.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:min_x, 181.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be less than or equal to 180.0" in errors_on(changeset).min_x
        end

        test "with min_x value less than -180.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:min_x, -181.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to -180.0" in errors_on(changeset).min_x
        end

        test "with min_y value greater than 90.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:min_y, 91.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be less than or equal to 90.0" in errors_on(changeset).min_y
        end

        test "with min_y value less than -90.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:min_y, -91.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to -90.0" in errors_on(changeset).min_y
        end

        test "with max_x value greater than 180.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:max_x, 181.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be less than or equal to 180.0" in errors_on(changeset).max_x
        end

        test "with max_x value less than -180.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:max_x, -181.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to -180.0" in errors_on(changeset).max_x
        end

        test "with max_y value greater than 90.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:max_y, 91.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be less than or equal to 90.0" in errors_on(changeset).max_y
        end

        test "with max_y value less than -90.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:max_y, -91.0)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to -90.0" in errors_on(changeset).max_y
        end

        test "with length_miles value less than 0.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:length_miles, D.new("-0.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).length_miles
        end

        test "with imperv_percent value greater than 100.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:imperv_percent, D.new("100.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be greater than 100.0" in errors_on(changeset).imperv_percent
        end

        test "with imperv_percent value less than 0.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:imperv_percent, D.new("-0.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).imperv_percent
        end

        test "with critical_facilities_count value less than 0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:critical_facilities_count, -1)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).critical_facilities_count
        end

        test "with coastal_structures_count value less than 0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:coastal_structures_count, -1)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).coastal_structures_count
        end

        test "with public_buildings_count value less than 0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:public_buildings_count, -1)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).public_buildings_count
        end

        test "with salt_marsh_acres value less than 0.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:salt_marsh_acres, D.new("-0.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).salt_marsh_acres
        end

        test "with eelgrass_acres value less than 0.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:eelgrass_acres, D.new("-0.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).eelgrass_acres
        end

        test "with public_beach_count value less than 0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:public_beach_count, -1)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).public_beach_count
        end

        test "with recreation_open_space_acres value less than 0.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:recreation_open_space_acres, D.new("-0.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).recreation_open_space_acres
        end

        test "with town_ways_to_water value less than 0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:town_ways_to_water, -1)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).town_ways_to_water
        end

        test "with total_assessed_value value less than 0.0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:total_assessed_value, D.new("-0.1"))
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "cannot be less than 0.0" in errors_on(changeset).total_assessed_value
        end

        test "littoral_cell_id field less than 0 returns error and changeset" do
            attrs = @attrs |> Map.replace!(:littoral_cell_id, -10)
            assert {:error, changeset} = ShorelineLocations.create_littoral_cell(attrs)
            assert "must be greater than or equal to 0" in errors_on(changeset).littoral_cell_id
        end

    end

end
