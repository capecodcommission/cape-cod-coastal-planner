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
                    this.clearZoneOfImpact();
                    this.clearVulnerabilityRibbon();
                    this.zoomToShorelineLocation(data);
                    break;

                case "littoral_cells_loaded":
                    this.littoralCellsLoaded(data);         
                    break;

                case "render_vulnerability_ribbon":
                    this.renderVulnerabilityRibbon(data);
                    break;

                case "clear_zone_of_impact":
                    this.clearZoneOfImpact();
                    break;

                case "render_location_hexes":
                    this.renderLocationHexes(data);
                    break;

                case "render_critical_facilities":
                    this.renderCriticalFacilities(data);
                    break;

                case "disable_critical_facilities":
                    this.disableCriticalFacilities(data);
                    break;
                
                case "render_disconnected_roads":
                    this.renderDisconnectedRoads(data);
                    break;

                case "disable_disconnected_roads":
                    this.disableDisconnectedRoads(data);
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

    clearVulnerabilityRibbon() {
        this.map.dispatchEvent({
            "type": "clear_vulnerability_ribbon"
        });
    }

    clearZoneOfImpact() {
        this.map.dispatchEvent({
            "type": "clear_zone_of_impact"
        });
    }

    renderLocationHexes(data) {
        this.map.dispatchEvent({
            "type": "render_location_hexes",
            "data": data
        });
    }

    renderCriticalFacilities(data) {
        this.map.dispatchEvent({
            "type": "render_critical_facilities",
            "data": data
        });
    }

    disableCriticalFacilities(data) {
        this.map.dispatchEvent({
            "type": "disable_critical_facilities"
        });
    }

    renderDisconnectedRoads(data) {
        this.map.dispatchEvent({
            "type": "render_disconnected_roads",
            "data": data
        });
    }

    disableDisconnectedRoads(data) {
        this.map.dispatchEvent({
            "type": "disable_disconnected_roads"
        });
    }

    getRibbonLayer() {
        let layers = this.map.getLayers().getArray().filter(l => {
            return l.get("name") === "vulnerability_ribbon";
        });
        return layers.length > 0 ? layers[0] : null;
    }

    getRibbonSelect() {
        let interactions = this.map.getInteractions().getArray().filter(i => {
            return i.get("name") === "select_vulnerability_ribbon";
        });
        return interactions.length > 0 ? interactions[0] : null;
    }
}

export { MapHandler as default };