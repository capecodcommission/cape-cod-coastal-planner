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

                case "render_slr":
                    this.renderSLR(data);
                    break;

                case "disable_sea_level_rise":
                    this.disableSLR(data);
                    break;

                case "render_municipally_owned_parcels":
                    this.renderMOP(data);
                    break;

                case "disable_municipally_owned_parcels":
                    this.disableMOP(data);
                    break;

                case "render_public_private_roads":
                    this.renderPPR(data);
                    break;

                case "disable_public_private_roads":
                    this.disablePPR(data);
                    break;

                case "render_sewered_parcels":
                    this.renderSP(data);
                    break;

                case "disable_sewered_parcels":
                    this.disableSP(data);
                    break;

                case "render_coastal_defense_structures":
                    this.renderCDS(data);
                    break;

                case "disable_coastal_defense_structures":
                    this.disableCDS(data);
                    break;

                case "render_flood_zones":
                    this.renderFZ(data);
                    break;

                case "disable_flood_zones":
                    this.disableFZ(data);
                    break;

                case "render_slosh_layer":
                    this.renderSlosh(data);
                    break;

                case "disable_slosh_layer":
                    this.disableSlosh(data);
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
        switch (data) {
            case "1":
                this.map.dispatchEvent({
                    "type": "render_dr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "render_dr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "render_dr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "render_dr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "render_dr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "render_dr6ft",
                    "data": data
                });
                break
        }
    }

    disableDisconnectedRoads(data) {
        switch (data) {
            case "1":
                this.map.dispatchEvent({
                    "type": "disable_dr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "disable_dr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "disable_dr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "disable_dr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "disable_dr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "disable_dr6ft",
                    "data": data
                });
                break
        }
    }

    renderSLR(data) {
        switch (data) {

            case "1":
                this.map.dispatchEvent({
                    "type": "render_slr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "render_slr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "render_slr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "render_slr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "render_slr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "render_slr6ft",
                    "data": data
                });
                break
        }
    }

    disableSLR(data) {
        switch (data) {

            case "1":
                this.map.dispatchEvent({
                    "type": "disable_slr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "disable_slr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "disable_slr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "disable_slr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "disable_slr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "disable_slr6ft",
                    "data": data
                });
                break
        }
    }

    renderMOP(data) {
        this.map.dispatchEvent({
            "type": "render_mop"
        });
    }

    disableMOP(data) {
        this.map.dispatchEvent({
            "type": "disable_mop"
        });
    }

    renderPPR(data) {
        this.map.dispatchEvent({
            "type": "render_ppr"
        });
    }

    disablePPR(data) {
        this.map.dispatchEvent({
            "type": "disable_ppr"
        });
    }

    renderSP(data) {
        this.map.dispatchEvent({
            "type": "render_sp"
        });
    }

    disableSP(data) {
        this.map.dispatchEvent({
            "type": "disable_sp"
        });
    }

    renderCDS(data) {
        this.map.dispatchEvent({
            "type": "render_cds"
        });
    }

    disableCDS(data) {
        this.map.dispatchEvent({
            "type": "disable_cds"
        });
    }

    renderFZ(data) {
        this.map.dispatchEvent({
            "type": "render_fz"
        });
    }

    disableFZ(data) {
        this.map.dispatchEvent({
            "type": "disable_fz"
        });
    }

    renderSlosh(data) {
        this.map.dispatchEvent({
            "type": "render_slosh"
        });
    }

    disableSlosh(data) {
        this.map.dispatchEvent({
            "type": "disable_slosh"
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