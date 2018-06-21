"use strict";

import {logError, getRAF} from "./misc";

class MapHandler {
    constructor() {
        this.map = null;
    }

    onCmd({cmd, data}) {
        try {
            switch(cmd) {
                case "init_map":
                    if (!this.map) {
                        this.map = initMap();
                    }
                    break;
    
                default:
                    throw new Error("Unhandled OpenLayers command from Elm port 'olCmd'.");
            }
        } catch (err) {
            logError(err);
        }
    }
}


import proj from "ol/proj";
import Map from "ol/map";
import View from "ol/view";

function initMap() {
    // pre-render initializations: view, layers, map
    let view = new View({
        center: proj.fromLonLat([-70.2962, 41.6688]),
        rotation: 0,
        zoom: 6,
        maxZoom: 19,
        minZoom: 3
    })

    // wait until next frame to attempt rendering the map
    // ie: target div needs to exist before attempt
    let raf = getRAF();
    raf(() => {
        if (document.getElementById("map") === null) {
            throw new Error("Map target 'map' cannot be found. Render failed...");
        }
        // render map


        // post-render initializations: controls, interactions
    });


}

export { MapHandler as default };