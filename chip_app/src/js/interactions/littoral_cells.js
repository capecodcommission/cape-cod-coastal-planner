"use strict";

import { Select } from "ol/interaction";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Text from "ol/style/Text";
import {pointerMove, singleClick, always} from "ol/events/condition";


/**
 * Hover functions
 */

 export function hover(map) {
     let layers = map.getLayers().getArray().filter(layer => {
         return layer.get("name") === "littoral_cells";
     });
     let hover = new Select({
         condition: pointerMove,
         hitTolerance: 8,
         style: _style,
         layers: layers
     });
     hover.set("name", "hover_littoral_cells");
    _onHover(hover);
    return hover;
 }

 function _onHover(hover) {
    hover.on('select', _hovered);
 }

 function _hovered(evt) {
    // turn on select littoral cell interaction
    let interactions = evt.target.getMap().getInteractions();
    interactions.forEach(interaction => {
        let name = interaction.get("name");
        if (!name) return;
        if (name === "select_littoral_cells") {
            interaction.setActive(true);
        } else if (name.includes("select_")) {
            interaction.setActive(false);
        }
    });

    // set cursor style
    let target = evt.target.getMap().getTarget();
    let node = document.getElementById(target);
    if (!node) return;
    if (evt.selected.length > 0) {
        node.style.cursor = "pointer";
    } else {
        node.style.cursor = "";
    }
 }


 /**
  * Hover Style functions
  */
 function _style(feature, resolution) {
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


 /**
  * Select functions
  */

export function select(map) {
    let layers = map.getLayers().getArray().filter(layer => {
        return layer.get("name") === "littoral_cells";
    });
    let select = new Select({
        hitTolerance: 8,
        style: new Style(),
        layers: layers
    });
    select.set("name", "select_littoral_cells");
    select.setActive(false);
    _onSingleClick(select);
    return select;
}

function _onSingleClick(select) {
    select.on('select', _clicked);
}

function _clicked(evt) {
    if (evt.selected.length === 0) return;
    let map = evt.target.getMap();
    let name = evt.selected[0].get("Littoral_Cell_Name");
    _selectCell(map, name);
    evt.target.getFeatures().clear();
}

function _selectCell(map, name) {
    map.dispatchEvent({
        "type": "olSub",
        "sub": "map_select_littoral_cell",
        "data": {
            "name": `${name}`
        }
    });
}