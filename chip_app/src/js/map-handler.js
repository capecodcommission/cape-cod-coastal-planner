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
import TileLayer from "ol/layer/tile";
import XYZ from "ol/source/xyz";

function initMap() {
    // pre-render initializations: view, layers, map
    let view = new View({
        center: proj.fromLonLat([-70.2962, 41.6688]),
        rotation: 0,
        zoom: 11,
        maxZoom: 19,
        minZoom: 3
    });
    let baselayer = new TileLayer({
        visible: true,
        preload: 4,
        source: new XYZ({
            crossOrigin: "anonymous",
            url: "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
            maxZoom: 16,
            minZoom: 3 ,
            tileLoadFunction: (imageTile, src) => {
                imageTile.getImage().src = src;
            }
        })
    });
    let map = new Map({
        view: view,
        layers: [baselayer],
        loadTilesWhileAnimating: true
    });

    // wait until next frame to attempt rendering the map
    // ie: target div needs to exist before attempt
    let raf = getRAF();
    raf(() => {
        if (document.getElementById("map") === null) {
            throw new Error("Map target 'map' cannot be found. Render failed...");
        }
        // render map
        map.setTarget("map");
        
        // post-render initializations: controls, interactions
        // nothing yet
    });
}

export { MapHandler as default };