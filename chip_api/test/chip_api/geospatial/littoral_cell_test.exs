defmodule ChipApi.Geospatial.LittoralCellTest do
    use ChipApi.DataCase, async: true
    alias ChipApi.Geospatial.LittoralCell

    @moduletag :geospatial_case
    @moduletag :littoral_cell_case

    setup do
        ChipApi.Fakes.run_littoral_cells()
    end

end