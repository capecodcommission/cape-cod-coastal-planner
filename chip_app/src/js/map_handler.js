"use strict";

import proj4 from "proj4";
import {register} from "ol/proj/proj4";
import {logError, convertExtent} from "./misc";
import {init as initMap} from "./map";

class MapHandler {
    constructor({onInit}) {
        if (!(typeof onInit === "function"))
            throw new Error("expecting an 'onInit' callback");
        this.onInit = onInit;
        register(proj4);
    }

    onCmd({cmd, data}) {
        try {
            switch(cmd) {
                case "init_map":
                    this.initialize();
                    break;

                case "zoom_to_shoreline_location":
                    this.zoomToShorelineLocation(data);
                    break;

                case "littoral_cells_loaded":
                    this.littoralCellsLoaded(data);         
                    break;

                case "render_vulnerability_ribbon":
                    this.renderVulnerabilityRibbon(data);
                    break;

                case "position_zone_of_impact_popup":
                    this.positionZoneOfImpactPopup(data);
                    break;

                default:
                    throw new Error("Unhandled OpenLayers command from Elm port 'olCmd'.");
            }
        } catch (err) {
            logError(err);
        }
    }

    initialize() {
        if (!this.map) {
            this.map = initMap(this.onInit);
        }
    }

    zoomToShorelineLocation(data) {
        if (!this.map) {
            throw Error("Map not initialized!");
        } else if (!data || !data.extent) {
            throw Error("Expected an extent!");
        } else {
            let extent3857 = convertExtent(data.extent);
            this.map.getView().fit(extent3857, {
                duration: 1000
            });
        }
    }

    littoralCellsLoaded(data) {
        this.map.dispatchEvent({
            "type": "littoral_cells_loaded",
            "data": data
        });
    }

    renderVulnerabilityRibbon(data) {
        this.map.dispatchEvent({
            "type": "render_vulnerability_ribbon",
            "data": data
        });
    }
}

export { MapHandler as default };