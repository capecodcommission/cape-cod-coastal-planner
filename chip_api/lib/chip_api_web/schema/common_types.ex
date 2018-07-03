defmodule ChipApi.Schema.CommonTypes do
    use Absinthe.Schema.Notation

    enum :sort_order do
        value :asc
        value :desc
    end
end