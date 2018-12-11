"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";

/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource({
        url: "http://gis-services.capecodcommission.org/arcgis/rest/services/Planimetrics/coastalDefenseStructures/MapServer/0/query?f=pjson&geometryType=esriGeometryPolygon&outFields=*&outSR=3857&returnGeometry=true&spatialRel=esriSpatialRelIntersects&where=1%3D1",
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                fill: new Fill({
                  color: 'red'
                })
            });
        }
    });
    layer.set("name", "coastal_defense_structures");

    map.on("render_cds", ({data}) => {
        layer.setVisible(true)
    });

    map.on("disable_cds", () => {
        layer.setVisible(false)
    });

    return layer;
}