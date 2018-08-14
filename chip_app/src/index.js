import './main.css';
import { Main } from './Main.elm';
import MapHandler from "./js/map-handler";
import { logError } from "./js/misc";
import closePath from "./img/close.png";
import registerServiceWorker from './registerServiceWorker';


window.chip = window.chip || {};

document.addEventListener("DOMContentLoaded", () => {
    chip.map = new MapHandler();
    
    chip.app = Main.fullscreen({
        "closePath": closePath,
        "size": {
            width: window.innerWidth,
            height: window.innerHeight
        }
    });

    // subscribe to error reports coming from Elm
    chip.app.ports.logErrorCmd.subscribe(logError);

    // subscribe to OL commands coming from Elm
    chip.app.ports.olCmd.subscribe(cmdData => {
        chip.map.onCmd(cmdData);
    });

    // subscribe to map events to send to Elm
    chip.map.map.on("olEvt", ({evt, data}) => {
        switch (evt) {
            case "load_littoral_cells": 
                break;
            default:
                return;
        }
    })
    
});

//registerServiceWorker();
