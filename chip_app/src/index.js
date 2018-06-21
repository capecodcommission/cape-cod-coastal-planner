import './main.css';
import { Main } from './Main.elm';
import MapHandler from "./js/map-handler";
import { logError } from "./js/misc";
import registerServiceWorker from './registerServiceWorker';


window.chip = window.chip || {};

document.addEventListener("DOMContentLoaded", () => {
    chip.map = new MapHandler();
    
    chip.app = Main.fullscreen();

    // subscribe to error reports coming from Elm
    chip.app.ports.logErrorCmd.subscribe(logError);

    // subscribe to OL commands
    chip.app.ports.olCmd.subscribe(cmdData => {
        chip.map.onCmd(cmdData);
    });
    
});

registerServiceWorker();
