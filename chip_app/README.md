# ChipApp

**Cape Cod Coastal Planner Front End**

> This front end serves the Cape Cod Coastal Planner user interface

## Getting Started
```bash
# Nativgate to project folder directory
cd cape-cod-coastal-planner/

# Run front-end service
docker-compose up --build front
```

## FROM Timmons Group
Note that to run this locally, you need to make sure `"proxy": "http://0.0.0.0:4000"` is added to elm-package.json. Additionally, be aware that if you add a new elm package, it seems to rewrite the elm-package.json file, removing the `proxy` entry, making it necessary to re-add. The proxy address is the address of your locally running `chip_api` backend. If the port for the api changes, this `proxy` entry will need to change to continue with local development. Also note that using `localhost` in place of `0.0.0.0` is sometimes necessary. I'm not entirely sure why, but I bet a sysops guy could tell you. :)

## Front-end Build Update Workflow

1. cd into local repo `/chip_app` & execute build command
```bash
cd /chip_app
yarn run build
```
2. Copy `/build` directory to server `/tmp` directory using FileZilla
3. ssh into instance as user vulcan. Enter password on prompt
```bash
ssh vulcan@10.19.180.6

# 4. Path to html directory (where build code goes)
cd /usr/share/nginx/html

# 5. Copy all files from /tmp/build/ directory to html directory
# Enter password on prompt
sudo cp -R /tmp/build/.

# 6. Remove build directory
rm -rf /tmp/build/
```