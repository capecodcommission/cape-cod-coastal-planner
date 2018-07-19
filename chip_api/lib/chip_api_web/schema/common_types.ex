defmodule ChipApi.Schema.CommonTypes do
    use Absinthe.Schema.Notation

    enum :sort_order do
        value :asc
        value :desc
    end

    # scalar :extent, name: "Geographic Extent" do
        
    #     parse fn input ->

    #     end

    #     serialize fn extent ->

    #     end

    # end

end