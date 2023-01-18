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
import {layer as pathwaysPoints} from "./layers/pathways_points"
// import {layer as pathways0ft} from "./layers/pathways0ft"
import {layer as pathways1ft} from "./layers/pathways1ft"
import {layer as pathways2ft} from "./layers/pathways2ft"
import {layer as pathways3ft} from "./layers/pathways3ft"
import {layer as pathways4ft} from "./layers/pathways4ft"
import {layer as pathways5ft} from "./layers/pathways5ft"
import {layer as pathways6ft} from "./layers/pathways6ft"
import {layer as pathways7ft} from "./layers/pathways7ft"
import {layer as pathways8ft} from "./layers/pathways8ft"
import {layer as pathways9ft} from "./layers/pathways9ft"
import {layer as pathways10ft} from "./layers/pathways10ft"
import {layer as dr1ft} from "./layers/dr1ft"
import {layer as dr2ft} from "./layers/dr2ft"
import {layer as dr3ft} from "./layers/dr3ft"
import {layer as dr4ft} from "./layers/dr4ft"
import {layer as dr5ft} from "./layers/dr5ft"
import {layer as dr6ft} from "./layers/dr6ft"
import {layer as slr1ft} from "./layers/slr1ft"
import {layer as slr2ft} from "./layers/slr2ft"
import {layer as slr3ft} from "./layers/slr3ft"
import {layer as slr4ft} from "./layers/slr4ft"
import {layer as slr5ft} from "./layers/slr5ft"
import {layer as slr6ft} from "./layers/slr6ft"
import {layer as mop} from "./layers/municipally_owned_parcels"
import {layer as ppr} from "./layers/public_private_roads"
import {layer as sp} from "./layers/sewered_parcels"
import {layer as cds} from "./layers/coastal_defense_structures"
import {layer as llr} from "./layers/low_lying_roads"
import {layer as fz} from "./layers/flood_zones"
import {layer as slosh} from "./layers/slosh"
import {layer as fourty_years} from "./layers/fourty_years"
import {layer as sti} from "./layers/sediment_transport_indicators"
import {layer as struct} from "./layers/structures"
import {layer as histDist} from "./layers/historic_districts" 
import {layer as histPlaces} from "./layers/historic_places" 
import LayerGroup from 'ol/layer/Group'
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
import {ImageArcGISRest, OSM} from 'ol/source';
import {Image as ImageLayer, Tile as TileLayer} from 'ol/layer';
let tileForImage = new TileLayer({
    source: new OSM(),
  });
export function init(onInit) {
    let map = new Map({
        view: _view(),
        layers: [
            worldImagery()
        ],
        loadTilesWhileAnimating: true,
        controls: []
    });

    map.addLayer(fz(map));
    map.addLayer(fourty_years(map));
    map.addLayer(slr6ft(map));
    map.addLayer(slr5ft(map));
    map.addLayer(slr4ft(map));
    map.addLayer(slr3ft(map));
    map.addLayer(slr2ft(map));
    map.addLayer(slr1ft(map));
    map.addLayer(slosh(map));
    map.addLayer(struct(map));
    map.addLayer(mop(map));
    map.addLayer(sp(map));
    map.addLayer(ppr(map));
    map.addLayer(cds(map));
    map.addLayer(dr6ft(map));
    map.addLayer(dr5ft(map));
    map.addLayer(dr4ft(map));
    map.addLayer(dr3ft(map));
    map.addLayer(dr2ft(map));
    map.addLayer(dr1ft(map));
    // map.addLayer(pathways0ft(map));
    map.addLayer(pathways1ft(map));
    map.addLayer(pathways2ft(map));
    map.addLayer(pathways3ft(map));
    map.addLayer(pathways4ft(map));
    map.addLayer(pathways5ft(map));
    map.addLayer(pathways6ft(map));
    map.addLayer(pathways7ft(map));
    map.addLayer(pathways8ft(map));
    map.addLayer(pathways9ft(map));
    map.addLayer(pathways10ft(map));
    map.addLayer(sti(map));
    map.addLayer(critFac(map));
    map.addLayer(pathwaysPoints(map));
    map.addLayer(vulnRibbon(map));
    map.addLayer(littoralCells(map));
    map.addLayer(histDist(map));
    map.addLayer(histPlaces(map));
    map.addLayer(llr(map));

    // hide all layers except base-layers
    map.on("clear_ol_layers", () => {

        let baseLayers = ['world_imagery', 'littoral_cells', 'vulnerability_ribbon']

        map.getLayers().forEach((layer) => {

            if ( !baseLayers.includes(layer.get('name')) ) {

                layer.setVisible(false)
            }
        })
    })


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
