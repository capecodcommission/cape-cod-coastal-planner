"use strict";

import VectorSource from "ol/source/Vector";
import VectorLayer from "ol/layer/Vector";
import EsriJSON from "ol/format/EsriJSON";
import {bbox} from "ol/loadingstrategy";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Text from "ol/style/Text";

const esrijsonformat = new EsriJSON();


/**
 * Vector Layer functions
 */

export function layer(map) {
    let source = _source(map);

    let layer = new VectorLayer({
        visible: true,
        source: source,
        style: _style
    });
    layer.set("name", "littoral_cells");
    return layer;
 }


/**
 * Vector Source functions
 */

function _source(map) {
    let source = new VectorSource({
        loader: (extent, resolution, projection) => {
            return _loader(source, map, {
                "extent": extent,
                "resolution": resolution,
                "projection": projection
            });
        },
        strategy: bbox
    });
    return source;
}

function _loader(source, map, data) {
    _onLoaded(source, map, data);
    _load(map, data.extent);
}

function _onLoaded(source, map, data) {
    map.on("littoral_cells_loaded", ({data}) => {
        return _loaded(source, data);
    });
}

function _loaded(source, data) {
    if (data.error) {
        source.removeLoadedExtent(source.getExtent());
    } else {
        let features = esrijsonformat.readFeaturesFromObject(data.response);
        if (features.length > 0) {
            source.addFeatures(features);
        }
    }
}

function _load(map, extent) {
    map.dispatchEvent({
        "type": "olSub",
        "sub": "load_littoral_cells", 
        "data": {
            "min_x": extent[0],
            "min_y": extent[1],
            "max_x": extent[2],
            "max_y": extent[3]
        }
    });
}

/**
 * Vector Style functions
 */

 function _style(feature, resolution) {
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
 }
