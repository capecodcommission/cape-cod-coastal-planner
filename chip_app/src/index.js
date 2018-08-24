import './main.css';
import { Main } from './Main.elm';
import MapHandler from "./js/map_handler";
import { logError } from "./js/misc";
import closePath from "./img/close.png";
import registerServiceWorker from './registerServiceWorker';

window.chip = window.chip || {};

document.addEventListener("DOMContentLoaded", () => {
    chip.mapHandler = new MapHandler({
        onInit: onMapHandlerInit
    });
    
    chip.app = Main.fullscreen({
        "env": {
            "agsLittoralCellUrl": process.env.ELM_APP_AGS_LITT_CELLS_URL,
            "agsVulnerabilityRibbonUrl": process.env.ELM_APP_AGS_SHORELINE_URL
        },
        "closePath": closePath,
        "size": {
            width: window.innerWidth,
            height: window.innerHeight
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
