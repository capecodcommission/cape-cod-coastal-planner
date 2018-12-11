"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import Style from "ol/style/Style";
import Stroke from "ol/style/Stroke";
import Fill from "ol/style/Fill";
import Circle from "ol/style/Circle";

const esrijsonformat = new EsriJSON();

/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = new VectorSource({
        url: 'http://gis-services.capecodcommission.org/arcgis/rest/services/Data_People/Infrastructure/MapServer/12/query?f=pjson&geometryType=esriGeometryPoint&outFields=*&outSR=3857&returnGeometry=true&spatialRel=esriSpatialRelIntersects&where=1%3D1',
        format: new EsriJSON()
    });

    let layer = new VectorLayer({
        visible: false,
        source: source,
        style: (feature, resolution) => {
            return new Style({
                image: new Circle({
                    radius: 3,
                    fill: new Fill({color: 'red'}),
                    stroke: new Stroke({
                        color: [255,0,0],
                        width: 2
                    })
                })
            });
        }
    });
    layer.set("name", "critical_facilities");

    map.on("render_critical_facilities", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_critical_facilities", () => {
        layer.setVisible(false);
    });

    return layer;
}