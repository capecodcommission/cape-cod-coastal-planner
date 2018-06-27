defmodule ChipApiWeb.SubscriptionCase do
    use ExUnit.CaseTemplate

    using do
        quote do
            use ChipApiWeb.ChannelCase
            use Absinthe.Phoenix.SubscriptionTest,
                schema: ChipApiWeb.Schema

            setup do
                ChipApi.Seeds.run()

                {:ok, socket} = Phoenix.ChannelTest.connect(ChipApiWeb.UserSocket, %{})
                {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

                {:ok, socket: socket}
            end
        end
    end
end