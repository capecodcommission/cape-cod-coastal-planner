This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

Below you will find some information on how to perform basic tasks.
You can find the most recent version of this guide [here](https://github.com/halfzebra/create-elm-app/blob/master/template/README.md).

## FROM Timmons Group
Note that to run this locally, you need to make sure `"proxy": "http://0.0.0.0:4000"` is added to elm-package.json. Additionally, be aware that if you add a new elm package, it seems to rewrite the elm-package.json file, removing the `proxy` entry, making it necessary to re-add. The proxy address is the address of your locally running `chip_api` backend. If the port for the api changes, this `proxy` entry will need to change to continue with local development. Also note that using `localhost` in place of `0.0.0.0` is sometimes necessary. I'm not entirely sure why, but I bet a sysops guy could tell you. :P

## Front-end Build Update Workflow

1. cd into local repo chip_app & execute 'yarn run build'
2. copy build directory to server /tmp/ location using FileZilla
3. ssh vulcan@10.19.180.6 <--- ssh into instance as user vulcan
4. cd /usr/share/nginx/html <--- path to html directory (where build code goes)
5. sudo cp -R /tmp/build/. . & enter vulcan password <--- copy all files from /tmp/build/ folder to html directory
6. rm -rf /tmp/build/ <--- remove build directory