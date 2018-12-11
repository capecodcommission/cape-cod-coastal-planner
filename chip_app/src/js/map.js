"use strict";

import {fromLonLat} from "ol/proj";
import Map from "ol/Map";
import View from "ol/View";
import {getRAF} from "./misc";
import {layer as worldImagery} from "./layers/world_imagery";
import {layer as massImagery} from "./layers/mass_imagery";
import {layer as littoralCells} from "./layers/littoral_cells";
import {layer as vulnRibbon} from "./layers/vulnerability_ribbon";
import {layer as critFac} from "./layers/critical_facilities"
import {layer as disCon} from "./layers/disconnected_roads"
import {layer as slr1ft} from "./layers/slr1ft"
import {layer as slr2ft} from "./layers/slr2ft"
import {layer as mop} from "./layers/municipally_owned_parcels"
import {layer as ppr} from "./layers/public_private_roads"
import {layer as sp} from "./layers/sewered_parcels"
import {layer as cds} from "./layers/coastal_defense_structures"
import {layer as fz} from "./layers/flood_zones"
import {layer as slosh} from "./layers/slosh"
//import {layer as locHexes} from "./layers/location_hexes";
import {
    layer as impactZone
} from "./layers/zone_of_impact";
import {
    hover as hoverLittoralCells, 
    select as selectLittoralCells
} from "./interactions/littoral_cells";
import {
    hover as hoverVulnRibbon,
    select as selectVulnRibbon
} from "./interactions/vulnerability_ribbon";

export function init(onInit) {
    let map = new Map({
        view: _view(),
        layers: [
            worldImagery(), 
            massImagery()
            // critFac()
        ],
        loadTilesWhileAnimating: true
    });
    map.addLayer(littoralCells(map));
    map.addLayer(vulnRibbon(map));
    map.addLayer(critFac(map))
    map.addLayer(disCon(map))
    map.addLayer(slr1ft(map))
    map.addLayer(slr2ft(map))
    map.addLayer(mop(map))
    map.addLayer(ppr(map))
    map.addLayer(sp(map))
    map.addLayer(cds(map))
    map.addLayer(fz(map))
    map.addLayer(slosh(map))
    //map.addLayer(locHexes(map));

    // wait until next frame to attempt rendering the map
    // ie: target div needs to exist before attempt
    let nextFrame = getRAF();
    nextFrame(() => {
        if (document.getElementById("map") === null) {
            throw new Error("Map target 'map' cannot be found. Render failed...");
        }
        // execute onInit callback function
        onInit(map);
        // render map
        map.setTarget("map");
        // post-render initializations: controls, interactions
        map.addInteraction(hoverLittoralCells(map));
        map.addInteraction(selectLittoralCells(map));
        map.addInteraction(hoverVulnRibbon(map));
        map.addInteraction(selectVulnRibbon(map));
        map.addLayer(impactZone(map)); // depends on selectVulnRibbon
    });

    return map;
}

function _view() {
    return new View({
        center: fromLonLat([-70.2962, 41.6688]),
        rotation: 0,
        zoom: 11,
        maxZoom: 19,
        minZoom: 3
    });
}
