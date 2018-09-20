"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import GeoJSON from "ol/format/GeoJSON";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import { union } from "@turf/turf";


/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource();

    let layer = new VectorLayer({
        visible: true,
        source: source,
        style: new Style({
            fill: new Fill({
                color: 'rgba(52,147,255,0.7)'
            }),
            stroke: new Stroke({
                color: "white",
                width: 4
            })
        })
    });
    layer.set("name", "zone_of_impact");

    let selectRibbon = map.getInteractions().getArray().filter(interaction => {
        return interaction.get("name") === "select_vulnerability_ribbon";
    })[0];
    selectRibbon.on("update_impact_zone", (evt) => {
        _onUpdate(evt, layer);
    });

    return layer;
}


const geojsonformat = new GeoJSON();
const esrijsonformat = new EsriJSON();

function _onUpdate(evt, layer) {
    let zoneOfImpact = evt.shape;
    let features = layer.getSource().getFeatures();
    if (features && features.length > 0) {
        let existingSelection = geojsonformat.writeFeaturesObject(features);
        let newSelection = geojsonformat.writeFeatureObject(evt.shape);
        let unionedSelection = union(newSelection, ...existingSelection.features);
        zoneOfImpact = geojsonformat.readFeatureFromObject(unionedSelection);        
    }
    layer.getSource().clear();
    layer.getSource().addFeature(zoneOfImpact);

    let esrijson = esrijsonformat.writeFeatureObject(zoneOfImpact);

    let num_selected = evt.target.get("num_selected") || 0;
    evt.target.getMap().dispatchEvent({
        "type": "olSub",
        "sub": "update_impact_zone",
        "data" : {
            "geometry": JSON.stringify(esrijson),
            "num_selected": num_selected
        }
    });
}

