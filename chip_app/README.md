This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

Below you will find some information on how to perform basic tasks.
You can find the most recent version of this guide [here](https://github.com/halfzebra/create-elm-app/blob/master/template/README.md).

Note that to run this locally, you need to make sure `"proxy": "http://0.0.0.0:4000"` is added to elm-package.json. Additionally, be aware that if you add a new elm package, it seems to rewrite the elm-package.json file, removing the `proxy` entry, making it necessary to re-add. The proxy address is the address of your locally running `chip_api` backend. If the port for the api changes, this `proxy` entry will need to change to continue with local development. Also note that using `localhost` in place of `0.0.0.0` does not appear to work, so don't be temped to change that! :)