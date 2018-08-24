"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import GeoJSON from "ol/format/GeoJSON";
import {bbox} from "ol/loadingstrategy";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Text from "ol/style/Text";
import Feature from "ol/Feature";
import Overlay from "ol/Overlay";
import { union, buffer, simplify } from "@turf/turf";
import { polygon, multiPolygon } from "@turf/helpers";


/**
 * Overlay functions
 */

export function popup(map) {
    let overlay = new Overlay({
        element: document.getElementById("zone-of-impact-popup"),
        autoPan: true,
        autoPanAnimation: {
            duration: 250
        }
    });

    map.addOverlay(overlay);

    map.on("position_zone_of_impact_popup")
}


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
                color: "rgba(52,147,255,0.7)",
                width: 1.25
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

function _onUpdate(evt, layer) {
    layer.getSource().clear();
    let unioned = unionSelectedFeatures(evt.target.getFeatures());
    layer.getSource().addFeature(unioned);
    evt.target.getMap().dispatchEvent({
        "type": "olSub",
        "sub": "popup_zone_of_impact",
        "data" : {
            "popup_state": {
                "state": "popup_enabled",
                "position": { x: evt.coordinate[0], y: evt.coordinate[1] } 
            }
        }
    });
}

function unionSelectedFeatures(features) {
    try {
        let featuresArray = features.getArray();
        let unionedSelection = featuresArray.reduce((accFeature, nextFeature) => {
            if (accFeature instanceof Feature) {
                accFeature = convertFeature(accFeature);
            }
            let convertedNextFeature = convertFeature(nextFeature);
            let unioned = union(accFeature, convertedNextFeature);
            return unioned;
        });

        let format = new GeoJSON();
        let newFeature = format.readFeatureFromObject(unionedSelection);
        return newFeature;
    } catch (err) {
        console.log(err);
    }
}

function convertFeature(feature) {
    let shape = null;
    let geom = feature.getGeometry();
    switch (geom.getType()) {
        case "Polygon":
            shape = polygon(geom.getCoordinates());
            break;
        case "MultiPolygon":
            shape = multiPolygon(geom.getCoordinates());
            break;
        default:
            throw new Error(`Invalid Geometry type: ${geometry.getType()}. Geometry must be either a Polygon or MultiPolygon.`);
    }
    return shape;
}
