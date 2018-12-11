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
        url: 'http://gis-services.capecodcommission.org/arcgis/rest/services/Data_People/Infrastructure/MapServer/25/query?f=pjson&geometryType=esriGeometryPolyline&outFields=*&outSR=3857&returnGeometry=true&spatialRel=esriSpatialRelIntersects&where=1%3D1',
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                stroke: new Stroke({
                  color: [255,0,0],
                  width: 2
                })
            });
        }
    });
    layer.set("name", "public_private_roads");

    map.on("render_ppr", ({data}) => {
        layer.setVisible(true)
    });

    map.on("disable_ppr", () => {
        layer.setVisible(false)
    });

    return layer;
}