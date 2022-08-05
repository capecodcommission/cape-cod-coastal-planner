"use strict";

import proj4 from "proj4";
import {fromLonLat} from "ol/proj";
import {register} from "ol/proj/proj4";
import {logError, convertExtent} from "./misc";
import {init as initMap} from "./map";
import Feature from 'ol/Feature';
import Style from 'ol/style/Style';
import CircleStyle from 'ol/style/Circle';
import Fill from 'ol/style/Fill';
import Stroke from 'ol/style/Stroke';
import Point from 'ol/geom/Point';
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/layer/Vector';
import Vector from 'ol/layer/Vector';
import jsPDF from 'jspdf';
import html2canvas from 'html2canvas';
import * as htmlToImage from 'html-to-image';
import { toPng, toJpeg, toBlob, toPixelData, toSvg } from 'html-to-image';

class AppHandler {
    constructor({onInit}) {
        if (!(typeof onInit === "function"))
            throw new Error("expecting an 'onInit' callback");
        this.onInit = onInit;
        register(proj4);
    }

    onCmd({cmd, data}) {
        try {
            switch(cmd) {
                case "init_map":
                    this.initialize();
                    break;

                case "create_report":
                    this.createReport();
                    break;

                case "littoral_cells_loaded":
                    this.littoralCellsLoaded(data);         
                    break;

                case "render_vulnerability_ribbon":
                    this.renderVulnerabilityRibbon(data);
                    break;

                case "clear_zone_of_impact":
                    this.clearZoneOfImpact();
                    break;

                case "render_location_hexes":
                    this.renderLocationHexes(data);
                    break;

                case "render_critical_facilities":
                    this.renderCriticalFacilities(data);
                    break;

                case "disable_critical_facilities":
                    this.disableCriticalFacilities(data);
                    break;
                
                case "render_disconnected_roads":
                    this.renderDisconnectedRoads(data);
                    break;

                case "disable_disconnected_roads":
                    this.disableDisconnectedRoads(data);
                    break;

                case "render_slr":
                    this.renderSLR(data);
                    this.renderDisconnectedRoads(data);
                    this.disableSLRLayers(data)
                    break;

                case "disable_sea_level_rise":
                    this.disableSLR(data);
                    this.disableDisconnectedRoads(data);
                    break;

                case "render_municipally_owned_parcels":
                    this.renderMOP(data);
                    break;

                case "disable_municipally_owned_parcels":
                    this.disableMOP(data);
                    break;

                case "render_public_private_roads":
                    this.renderPPR(data);
                    break;

                case "disable_public_private_roads":
                    this.disablePPR(data);
                    break;

                case "render_sewered_parcels":
                    this.renderSP(data);
                    break;

                case "disable_sewered_parcels":
                    this.disableSP(data);
                    break;

                case "render_coastal_defense_structures":
                    this.renderCDS(data);
                    break;

                case "disable_coastal_defense_structures":
                    this.disableCDS(data);
                    break;

                case "render_flood_zones":
                    this.renderFZ(data);
                    break;

                case "disable_flood_zones":
                    this.disableFZ(data);
                    break;

                case "render_slosh_layer":
                    this.renderSlosh(data);
                    break;

                case "disable_slosh_layer":
                    this.disableSlosh(data);
                    break;

                case "render_fourty_years":
                    this.renderFourtyYears(data);
                    break;

                case "disable_fourty_years":
                    this.disableFourtyYears(data);
                    break;

                case "render_sediment_transport":
                    this.renderSTI(data);
                    break;

                case "disable_sediment_transport":
                    this.disableSTI(data);
                    break;
                
                case "clear_layers":
                    this.clearLayers()
                    break

                case "render_structures":
                    this.renderStructures(data);
                    break;

                case "disable_structures":
                    this.disableStructures(data);
                    break;

                case "render_historic_districts":
                    this.renderHistoricDistricts(data);
                    break;
    
                case "disable_historic_districts":
                    this.disableHistoricDistricts(data);
                    break;
                    
                case "render_historic_places":
                    this.renderHistoricPlaces(data);
                    break;
            
                case "disable_historic_places":
                    this.disableHistoricPlaces(data);
                    break;

                case "render_low_lying_roads":
                    this.renderLLR(data);
                    break;

                case "disable_low_lying_roads":
                    this.disableLLR(data);
                    break;

                case "reset_all":
                    this.clearLayers()
                    this.clearVulnerabilityRibbon()
                    this.clearZoneOfImpact();
                    this.resetView()
                    break;

                case "zoom_in":
                    this.zoomIn()
                    break;

                case "zoom_out":
                    this.zoomOut()
                    break;

                case "get_loc":
                    this.getLoc()
                    break;

                case "render_vuln_ribbon":
                    this.renderVulnRibbon();         
                    break;

                case "disable_vuln_ribbon":
                    this.disableVulnRibbon();         
                    break;

                default:
                    throw new Error("Unhandled OpenLayers command from Elm port 'olCmd'.");
            }
        } catch (err) {
            logError(err);
        }
    }
    filterElement (node) {
        return (node.tagName !== 'svg');
      }
    createReport() {
        var doc = new jsPDF({
            orientation: "landscape",
            unit: "px",
            hotfixes: ["px_scaling"]
          });
          const pageWidth = doc.internal.pageSize.getWidth();
          const pageHeight = doc.internal.pageSize.getHeight();
        doc.setFont("arial");
        doc.setTextColor(80,80,80);
        doc.setFontSize(16);
        
        //== logo image settings
        //let logoImg = document.getElementById('logoImg');
        let logoImg = document.getElementById('hazIcon');
        let logoImgOriWidth = logoImg.offsetWidth;
        let logoImgoOriHeight = logoImg.offsetHeight;

        let logoImgRatio = 375/logoImgOriWidth;

        let logoImgWidth = logoImgOriWidth*logoImgRatio;
        let logoImgHeight = logoImgoOriHeight*logoImgRatio;
        
        //== main image settings
        let node = document.getElementById('map');
        let oriWidth = node.offsetWidth;
        let oriHeight = node.offsetHeight;
        let pdfRatio = 1000/oriWidth;    //1000px is target width
        if(oriHeight*pdfRatio > 605){
            pdfRatio = 605/oriHeight;
        }
        
        var imgWidth = oriWidth*pdfRatio;
        var imgHeight = oriHeight*pdfRatio
        
        const marginX = (pageWidth - imgWidth) / 2;
        const marginY = (pageHeight - imgHeight) / 2;

        //== add images
        // htmlToImage.toPng(logoImg, {canvasWidth: logoImgWidth, canvasHeight: logoImgHeight, backgroundColor: "#193446"})
        // .then(function (dataUrl) {
        //     var img = new Image();
        //     img.src = dataUrl;
        //     doc.addImage(img, 'PNG', marginX, 30, logoImgWidth, logoImgHeight);
        // })
        // .catch(function (error) {
        //     console.error('oops, something went wrong!', error);
        // });

        
        // html2canvas(logoImg, {
        //   }).then((canvas) => {
        //     const img = canvas.toDataURL("image/png");
        //     var doc = new jsPDF({
        //         orientation: "landscape",
        //         unit: "px",
        //         hotfixes: ["px_scaling"]
        //       });
        //     doc.addImage(img, "PNG", 30, 30, 168, 65);
        //     doc.save("p&lstatement.pdf");
        //   })
        htmlToImage.toPng(node, {canvasWidth: imgWidth, canvasHeight: imgHeight, filter: this.filterElement })
        .then(function (dataUrl) {
            var img = new Image();
            img.src = dataUrl;
            doc.addImage(img, 'PNG', marginX, marginY, imgWidth, imgHeight);
            doc.save('CapeCod_CoastalPlanner.pdf');
        })
        .catch(function (error) {
            console.error('oops, something went wrong!', error);
        });
        
    }
    initialize() {
        if (!this.map) {
            this.map = initMap(this.onInit);
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

    clearLayers() {
        this.map.dispatchEvent({
            "type": "clear_ol_layers"
        })
    }

    renderStructures() {
        this.map.dispatchEvent({
            "type": "render_struct"
        })
    }

    disableStructures() {
        this.map.dispatchEvent({
            "type": "disable_struct"
        })
    }

    littoralCellsLoaded(data) {
        this.map.dispatchEvent({
            "type": "littoral_cells_loaded",
            "data": data
        });
    }

    renderVulnerabilityRibbon(data) {
        this.map.dispatchEvent({
            "type": "render_vulnerability_ribbon",
            "data": data
        });
    }

    clearVulnerabilityRibbon() {
        this.map.dispatchEvent({
            "type": "clear_vulnerability_ribbon"
        });
    }
    
    clearZoneOfImpact() {
        this.map.dispatchEvent({
            "type": "clear_zone_of_impact"
        });
    }

    renderLocationHexes(data) {
        this.map.dispatchEvent({
            "type": "render_location_hexes",
            "data": data
        });
    }

    renderCriticalFacilities(data) {
        this.map.dispatchEvent({
            "type": "render_critical_facilities",
            "data": data
        });
    }

    disableCriticalFacilities(data) {
        this.map.dispatchEvent({
            "type": "disable_critical_facilities"
        });
    }

    renderDisconnectedRoads(data) {
        switch (data) {
            case "1":
                this.map.dispatchEvent({
                    "type": "render_dr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "render_dr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "render_dr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "render_dr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "render_dr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "render_dr6ft",
                    "data": data
                });
                break
        }
    }

    disableDisconnectedRoads(data) {
        switch (data) {
            case "1":
                this.map.dispatchEvent({
                    "type": "disable_dr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "disable_dr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "disable_dr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "disable_dr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "disable_dr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "disable_dr6ft",
                    "data": data
                });
                break
        }
    }

    renderSLR(data) {

        switch (data) {

            case "1":
                this.map.dispatchEvent({
                    "type": "render_slr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "render_slr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "render_slr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "render_slr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "render_slr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "render_slr6ft",
                    "data": data
                });
                break
        }
    }

    disableSLR(data) {
        switch (data) {

            case "1":
                this.map.dispatchEvent({
                    "type": "disable_slr1ft",
                    "data": data
                });
                break

            case "2":
                this.map.dispatchEvent({
                    "type": "disable_slr2ft",
                    "data": data
                });
                break

            case "3":
                this.map.dispatchEvent({
                    "type": "disable_slr3ft",
                    "data": data
                });
                break

            case "4":
                this.map.dispatchEvent({
                    "type": "disable_slr4ft",
                    "data": data
                });
                break

            case "5":
                this.map.dispatchEvent({
                    "type": "disable_slr5ft",
                    "data": data
                });
                break

            case "6":
                this.map.dispatchEvent({
                    "type": "disable_slr6ft",
                    "data": data
                });
                break
        }
    }

    renderMOP(data) {
        this.map.dispatchEvent({
            "type": "render_mop"
        });
    }

    disableMOP(data) {
        this.map.dispatchEvent({
            "type": "disable_mop"
        });
    }

    renderPPR(data) {
        this.map.dispatchEvent({
            "type": "render_ppr"
        });
    }

    disablePPR(data) {
        this.map.dispatchEvent({
            "type": "disable_ppr"
        });
    }

    renderSP(data) {
        this.map.dispatchEvent({
            "type": "render_sp"
        });
    }

    disableSP(data) {
        this.map.dispatchEvent({
            "type": "disable_sp"
        });
    }

    renderCDS(data) {
        this.map.dispatchEvent({
            "type": "render_cds"
        });
    }

    disableCDS(data) {
        this.map.dispatchEvent({
            "type": "disable_cds"
        });
    }

    renderFZ(data) {
        this.map.dispatchEvent({
            "type": "render_fz"
        });
    }

    disableFZ(data) {
        this.map.dispatchEvent({
            "type": "disable_fz"
        });
    }

    renderSlosh(data) {
        this.map.dispatchEvent({
            "type": "render_slosh"
        });
    }

    disableSlosh(data) {
        this.map.dispatchEvent({
            "type": "disable_slosh"
        });
    }

    renderFourtyYears(data) {
        this.map.dispatchEvent({
            "type": "render_fourty_years_layer"
        });
    }

    disableFourtyYears(data) {
        this.map.dispatchEvent({
            "type": "disable_fourty_years_layer"
        });
    }

    renderSTI(data) {
        this.map.dispatchEvent({
            "type": "render_sti"
        });
    }

    disableSTI(data) {
        this.map.dispatchEvent({
            "type": "disable_sti"
        });
    }

    renderHistoricDistricts(data) {
        this.map.dispatchEvent({
            "type": "render_historic_districts"
        });
    }

    disableHistoricDistricts(data) {
        this.map.dispatchEvent({
            "type": "disable_historic_districts"
        });
    }

    renderHistoricPlaces(data) {
        this.map.dispatchEvent({
            "type": "render_historic_places"
        });
    }

    disableHistoricPlaces(data) {
        this.map.dispatchEvent({
            "type": "disable_historic_places"
        });
    }

    renderLLR(data) {
        this.map.dispatchEvent({
            "type": "render_llr"
        });
    }

    disableLLR(data) {
        this.map.dispatchEvent({
            "type": "disable_llr"
        });
    }

    getRibbonLayer() {
        let layers = this.map.getLayers().getArray().filter(l => {
            return l.get("name") === "vulnerability_ribbon";
        });
        return layers.length > 0 ? layers[0] : null;
    }

    getRibbonSelect() {
        let interactions = this.map.getInteractions().getArray().filter(i => {
            return i.get("name") === "select_vulnerability_ribbon";
        });
        return interactions.length > 0 ? interactions[0] : null;
    }

    disableSLRLayers(data) {

        const disSLRLayers = ["disable_slr1ft", "disable_slr2ft", "disable_slr3ft", "disable_slr4ft", "disable_slr5ft", "disable_slr6ft"]
        const disDRLayers = ["disable_dr1ft", "disable_dr2ft", "disable_dr3ft", "disable_dr4ft", "disable_dr5ft", "disable_dr6ft"]

        disSLRLayers.map((layer) => {
            if (layer != "disable_slr" + data + "ft") {
                this.map.dispatchEvent({
                    "type": layer,
                    "data": data
                });
            }
        })

        disDRLayers.map((layer) => {
            if (layer != "disable_dr" + data + "ft") {
                this.map.dispatchEvent({
                    "type": layer,
                    "data": data
                });
            }
        })
    }

    resetView() {
        let view = this.map.getView()
        view.animate({
            center: fromLonLat([-70.2962, 41.6688]),
            zoom: 11,
            duration: 1000
        })
    }

    zoomIn() {
        let view = this.map.getView()
        view.animate({
            zoom: view.getZoom() + 1,
            duration: 500
        })
    }

    zoomOut() {
        let view = this.map.getView()
        view.animate({
            zoom: view.getZoom() - 1,
            duration: 500
        })
    }

    getLoc() {
        let view = this.map.getView()
        navigator.geolocation.getCurrentPosition((pos) => {
            const coords = fromLonLat([pos.coords.longitude, pos.coords.latitude]);
            view.animate({center: coords, zoom: 16});
        })
    }

    renderVulnRibbon() {
        this.map.dispatchEvent({
            "type": "render_vuln_ribbon"
        })
    }

    disableVulnRibbon(){
        this.map.dispatchEvent({
            "type": "disable_vuln_ribbon"
        })
    }
}

export { AppHandler as default };