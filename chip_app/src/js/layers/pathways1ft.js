"use strict";

import TileLayer from "ol/layer/Tile";
import XYZ from "ol/source/XYZ";

import MVT from 'ol/format/MVT';
import VectorTileLayer from 'ol/layer/VectorTile';
import VectorTileSource from 'ol/source/VectorTile';

export function layer(map) {
    let source = _source();

    let layer = new VectorTileLayer({
        visible: false,
        preload: 4,
        opacity: 1,
        source: source
    });
    layer.set("name", "stormtide_pathways_1ft");

    map.on("render_stp1ft", ({data}) => {
        layer.setVisible(true);
    });

    map.on("disable_stp1ft", () => {
        layer.setVisible(false);
    });

    return layer;
}

function _source() {
    let source = new VectorTileSource({
        format: new MVT(),
        url: process.env.ELM_APP_AGS_PATHWAYS_ONE,
        maxZoom: 16,
        minZoom: 3,
        opaque: true,
        transition: 4
        
    });
    return source;
}
