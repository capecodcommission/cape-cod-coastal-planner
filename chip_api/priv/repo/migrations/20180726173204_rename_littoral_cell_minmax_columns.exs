defmodule ChipApi.Repo.Migrations.RenameLittoralCellMinmaxColumns do
  use Ecto.Migration

  def change do

    rename table("littoral_cells"), :minX, to: :min_x

    rename table("littoral_cells"), :minY, to: :min_y

    rename table("littoral_cells"), :maxX, to: :max_x

    rename table("littoral_cells"), :maxY, to: :max_y

  end
end
