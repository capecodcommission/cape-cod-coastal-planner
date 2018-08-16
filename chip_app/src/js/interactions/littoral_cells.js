"use strict";

import { Select } from "ol/interaction";
import Style from "ol/style/Style";
import Fill from "ol/style/Fill";
import Stroke from "ol/style/Stroke";
import Text from "ol/style/Text";
import {pointerMove} from "ol/events/condition";


/**
 * Hover Select functions
 */

 export function hover(map) {
     let select = new Select({
         condition: pointerMove,
         hitTolerance: 8,
         style: _style
     });
    _onHover(select);
    return select;
 }

 function _onHover(select) {
     select.on('select', _hovered);
 }

 function _hovered(evt) {
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
  * Hover Select Style functions
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