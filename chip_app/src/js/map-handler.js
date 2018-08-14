"use strict";

import proj4 from "proj4";
import {fromLonLat} from "ol/proj";
import {register} from "ol/proj/proj4";
import Map from "ol/map";
import View from "ol/View";
import TileLayer from "ol/layer/tile";
import XYZ from "ol/source/xyz";
import {logError, getRAF, convertExtent} from "./misc";

class MapHandler {
    constructor() {
        this.map = null;
    }

    onCmd({cmd, data}) {
        try {
            switch(cmd) {
                case "init_map":
                    this.initialize();
                    break;

                case "zoom_to_shoreline_location":
                    this.zoomToShorelineLocation(data);
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
            this.map = initMap();
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
}


import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import {bbox} from "ol/loadingstrategy";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Text from "ol/style/Text";
function addLittCells(map) {
    const url = "https://gis-services.capecodcommission.org/arcgis/rest/services/Test/hexagonGeoJSON/MapServer/2";
    const esrijsonformat = new EsriJSON();
    let source = new VectorSource({
        loader: (extent, resolution, projection) => {
            let proj = projection.getCode();
            proj = 4326;
            let encodedExtent = `${extent[0]},${extent[1]},${extent[2]},${extent[3]}`;
            encodedExtent = `-70.68869066199994,41.51431148300003,-69.92634771999997,42.083433967000076`
            let serviceUrl = `${url}/query?f=json&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometry=${encodedExtent}&geometryType=esriGeometryEnvelope&inSR=${proj}&outFields=*&outSR=3857`;

            let xhr = new XMLHttpRequest();
            xhr.open('GET', serviceUrl);
            let onError = () => {
                source.removeLoadedExtent(extent);
            }
            xhr.onerror = onError;
            xhr.onload = () => {
                if (xhr.status == 200) {
                    let features = esrijsonformat.readFeatures(xhr.responseText);                    
                    if (features.length > 0) {
                        source.addFeatures(features);
                    }
                } else {
                    onError();
                }
            }
            xhr.send();
        },
        strategy: bbox
    });

    
    let layer = new VectorLayer({
        visible: true,
        source: source,
        style: littCellStyle
    });
    map.addLayer(layer);
}

function littCellStyle(feature, resolution) {
    return new Style({
        text: new Text({
            textAlign: 'center',
            textBaseline: 'alphabetic',
            font: '14px Tahoma',
            text: feature.get('Littoral_Cell_Name'),
            fill: new Fill({color: 'white'}),
            stroke: new Stroke({color: 'blue', width: 1}),
            offsetX: 0,
            offsetY: 0,
            placement: 'point',
            overflow: true
        })
    });
};

function littCellHoverStyle(feature, resolution) {
    return [
        new Style({
            fill: new Fill({
                color: 'rgba(255,255,255,0.4)',
            }),
            stroke: new Stroke({
                color: "white",
                width: 5
            })
        }),
        new Style({
            stroke: new Stroke({
                color: "#3399CC",
                width: 3
            }),
            text: new Text({
                textAlign: 'center',
                textBaseline: 'alphabetic',
                font: '14px Tahoma',
                text: feature.get('Littoral_Cell_Name'),
                fill: new Fill({color: 'white'}),
                stroke: new Stroke({color: 'blue', width: 1}),
                offsetX: 0,
                offsetY: 0,
                placement: 'point',
                overflow: true
            })
        })
    ];
}

import Select from "ol/interaction/Select";
import {pointerMove} from "ol/events/condition";
function addLittCellHover(map) {
    let select = new Select({
        condition: pointerMove,
        hitTolerance: 8,
        style: littCellHoverStyle
    });

    select.on('select', evt => {
        let target = evt.target.getMap().getTarget();
        let node = document.getElementById(target);
        if (evt.selected.length > 0) {
            node.style.cursor = "pointer";
        } else {
            node.style.cursor = "";
        }
    })
    map.addInteraction(select);
 
}

function initMap() {
    register(proj4);
    // pre-render initializations: view, layers, map
    let view = new View({
        center: fromLonLat([-70.2962, 41.6688]),
        rotation: 0,
        zoom: 11,
        maxZoom: 19,
        minZoom: 3
    });
    let baselayer = new TileLayer({
        visible: true,
        preload: 4,
        source: new XYZ({
            crossOrigin: "anonymous",
            url: "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
            maxZoom: 16,
            minZoom: 3 ,
            tileLoadFunction: (imageTile, src) => {
                imageTile.getImage().src = src;
            }
        })
    });
    let map = new Map({
        view: view,
        layers: [baselayer],
        loadTilesWhileAnimating: true
    });

    // wait until next frame to attempt rendering the map
    // ie: target div needs to exist before attempt
    let raf = getRAF();
    raf(() => {
        if (document.getElementById("map") === null) {
            throw new Error("Map target 'map' cannot be found. Render failed...");
        }
        // render map
        map.setTarget("map");
        // post-render initializations: controls, interactions
        addLittCells(map);
        addLittCellHover(map);
    });

    return map;
}

export { MapHandler as default };