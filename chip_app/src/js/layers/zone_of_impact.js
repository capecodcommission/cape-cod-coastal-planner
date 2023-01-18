"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import GeoJSON from "ol/format/GeoJSON";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import { union, toWgs84 } from "@turf/turf";


/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource();

    let layer = new VectorLayer({
        visible: false,
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

    map.on("clear_zone_of_impact", () => {
        layer.getSource().clear();
    });

    return layer;
}


const geojsonformat = new GeoJSON();
const esrijsonformat = new EsriJSON();

function _onUpdate(evt, layer) {

    let zoneOfImpact = evt.shape;
    let isDeselect = evt.deselected;
    let features = layer.getSource().getFeatures();
    if (features && features.length > 0) {
        let existingSelection = geojsonformat.writeFeaturesObject(features);
        let newSelection = geojsonformat.writeFeatureObject(evt.shape);
        if (isDeselect == 0){   // if it is select event
            //let unionedSelection = union(newSelection, ...existingSelection.features);
            // somehow "..." above create wrong unioned shape
            let unionedSelection = union(newSelection, existingSelection.features[0]);
            if(existingSelection.features.length > 1){
                existingSelection.features.forEach((item, i) => {
                    if(i > 0){
                        unionedSelection=union(unionedSelection,item);
                    }
                });
            }
            zoneOfImpact = geojsonformat.readFeatureFromObject(unionedSelection); 
        }
        else {   // if it is deselect event
            
            zoneOfImpact = geojsonformat.readFeatureFromObject(newSelection);
        }
               
    }
    layer.getSource().clear();
    let hasFeatures = false;
    let stripped = { rings: [] };
    if (zoneOfImpact.values_)
        hasFeatures = true;
    if(hasFeatures){
        layer.getSource().addFeature(zoneOfImpact);

        let esrijson = esrijsonformat.writeFeatureObject(zoneOfImpact);
        stripped = { rings: esrijson.geometry.rings };

    }
    
    let num_selected = evt.target.get("num_selected") || 0;
    evt.target.getMap().dispatchEvent({
        "type": "olSub",
        "sub": "update_impact_zone",
        "data" : {
            "geometry": JSON.stringify(stripped),
            "num_selected": num_selected,
            "beach_lengths": evt.lengths,
            "placements": evt.placements
        }
    });
}

