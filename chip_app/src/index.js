import './main.css';
import { Main } from './Main.elm';
import MapHandler from "./js/map_handler";
import { logError } from "./js/misc";
import closePath from "./img/close.png";
import trianglePath from "./img/triangle.png";
import zoiPath from "./img/zoi.png";
import slrPath from "./img/SeaLevelRise.png"
import wetPath from "./img/wetlands.png"
import shorePath from "./img/shoreline.png"
import logoPath from "./img/logo.png"
import downArrow from "./img/downArrow.png"
import registerServiceWorker from './registerServiceWorker';

window.chip = window.chip || {};

document.addEventListener("DOMContentLoaded", () => {
    chip.mapHandler = new MapHandler({
        onInit: onMapHandlerInit
    });
    
    chip.app = Main.fullscreen({
        "env": {
            "agsLittoralCellUrl": process.env.ELM_APP_AGS_LITT_CELLS_URL,
            "agsVulnerabilityRibbonUrl": process.env.ELM_APP_AGS_VULN_RIBBON_URL,
            "agsHexUrl": process.env.ELM_APP_AGS_HEX_URL,
            "agsCritUrl": process.env.ELM_APP_AGS_CRIT_URL,
            "agsAPIUrl": process.env.ELM_APP_AGS_API_URL
        },
        "closePath": closePath,
        "trianglePath": trianglePath,
        "zoiPath": zoiPath,
        "size": {
            width: window.innerWidth,
            height: window.innerHeight
        },
        "slrPath": slrPath,
        "wetPath": wetPath,
        "paths": {
            "slrPath": slrPath,
            "wetPath": wetPath,
            "closePath": closePath,
            "trianglePath": trianglePath,
            "zoiPath": zoiPath,
            "shorePath": shorePath,
            "logoPath": logoPath,
            "downArrow": downArrow
        }
    });

    // subscribe to error reports coming from Elm
    chip.app.ports.logErrorCmd.subscribe(logError);

    // subscribe to OL commands coming from Elm
    chip.app.ports.olCmd.subscribe(cmdData => {
        chip.mapHandler.onCmd(cmdData);
    });
});

function onMapHandlerInit(map) {
    // subscribe to map events to send to Elm
    map.on("olSub", ({sub, data}) => {
        chip.app.ports.olSub.send({sub, data});
    });
}

// Uncomment to enable as PWA. We had issues with the offline caching when enabled by default and since it's
// not a priority to have this feature, time has yet to be devoted to examining how to configure/implement CHIP
// as a PWA. This could be a good upgrade point for the app, however, and you'd start here by registering the service worker.
//registerServiceWorker();
