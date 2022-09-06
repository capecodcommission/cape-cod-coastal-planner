"use strict";

import {logError, convertExtent} from "./misc";
import jsPDF from 'jspdf';
import * as htmlToImage from 'html-to-image';

class AppHandler {
    constructor({onInit}) {
        if (!(typeof onInit === "function"))
            throw new Error("expecting an 'onInit' callback");
        this.onInit = onInit;
    }

    onCmd({cmd, data}) {
        try {
            switch(cmd) {
                case "create_report":
                    this.createReport();
                    break;
                default:
                    throw new Error("Unhandled OpenLayers command from Elm port 'olCmd'.");
            }
        } catch (err) {
            logError(err);
        }
    }

    // filterElement (node) {
    //     return (node.tagName !== 'svg');
    // }
    hasDST(date = new Date()) {
        const january = new Date(date.getFullYear(), 0, 1).getTimezoneOffset();
        const july = new Date(date.getFullYear(), 6, 1).getTimezoneOffset();
      
        return Math.max(january, july) !== date.getTimezoneOffset();
      }
    createReport() {
        var doc = new jsPDF({
            orientation: "landscape",
            unit: "px",
            hotfixes: ["px_scaling"]
        });
        const pageWidth = doc.internal.pageSize.getWidth();
        const pageHeight = doc.internal.pageSize.getHeight();
        let maxWidth = 1000;
        let maxHeight = 450;
        let gap = 5;
        //== header rectangle
        let rectangleHeight = 45;
        let rectangleX = (pageWidth - maxWidth) / 2;
        let rectangleY = 80;
        doc.setDrawColor(0);
        doc.setFillColor(25,52,70);
        doc.rect(rectangleX, rectangleY, maxWidth, rectangleHeight, 'F');
        
        //== description rectangle
        let descRectangleHeight = 110;
        let descRectangleX = rectangleX;
        let descRectangleY = rectangleY + rectangleHeight+gap;
        doc.setDrawColor(0);
        doc.setFillColor(83,168,171);
        doc.rect(descRectangleX, descRectangleY, maxWidth, descRectangleHeight, 'F');

//==footer rectangle
        let footerRectangleHeight = 20;
        let footerRectagleX = rectangleX;
        let footerRectangleY = pageHeight-90;
        doc.rect(footerRectagleX, footerRectangleY, maxWidth, footerRectangleHeight, 'F');

        doc.setFont("helvetica");
        doc.setTextColor(255,255,255);
        doc.setFontSize(9);
        let cccDesc1 = "The Cape Cod Coastal Planner is an interactive tool designed to improve understanding of the coastal hazards threatening Cape Cod, including erosion, sea level rise, and storm surge.";
        let cccDesc2 = "It is intended to illustrate potential impacts based on data of on-the-ground conditions in combination with anticipated threats from coastal hazards and the application of shoreline ";
        let cccDesc3 = "management strategies.";
        let cccDesc4 = "This report summarizes the scenario you selected and the associated outputs. The tool data layers, strategies, and projected results are intended for educational and planning purposes ";
        let cccDesc5 = "only, and may not be used for engineering solutions, or in support of or against any given strategy.";

        let cccDesc1XOffset = (pageWidth / 2) - (doc.getStringUnitWidth(cccDesc1) * doc.internal.getFontSize() / 2); 
        let cccDesc2XOffset = (pageWidth / 2) - (doc.getStringUnitWidth(cccDesc2) * doc.internal.getFontSize() / 2); 
        let cccDesc3XOffset = (pageWidth / 2) - (doc.getStringUnitWidth(cccDesc3) * doc.internal.getFontSize() / 2); 
        let cccDesc4XOffset = (pageWidth / 2) - (doc.getStringUnitWidth(cccDesc4) * doc.internal.getFontSize() / 2); 
        let cccDesc5XOffset = (pageWidth / 2) - (doc.getStringUnitWidth(cccDesc5) * doc.internal.getFontSize() / 2); 
        doc.text(cccDesc1, pageWidth/2, descRectangleY+24, { align: 'center' });
        doc.text(cccDesc2, pageWidth/2, descRectangleY+40, { align: 'center' });
        doc.text(cccDesc3, pageWidth/2, descRectangleY+54, { align: 'center' });
        doc.text(cccDesc4, pageWidth/2, descRectangleY+73, { align: 'center' });
        doc.text(cccDesc5, pageWidth/2, descRectangleY+88, { align: 'center' });
        // doc.text(cccDesc1, descRectangleX+10, descRectangleY+20, {align:'center', maxWidth: 960});
        // doc.text(cccDesc2, descRectangleX+10, descRectangleY+34, {align:'center'});
        // doc.text(cccDesc3, descRectangleX+10, descRectangleY+48, {align:'center'});
        // doc.text(cccDesc4, descRectangleX+10, descRectangleY+62, {align:'center'});
        // doc.text(cccDesc5, descRectangleX+10, descRectangleY+76, {align:'center'});
        let footerText1 = "www.capecodcoast.org";
        let footerText2 = "Funded by a NOAA Coastal Resilience Grant awared to the Cape Cod Commission and partner agencies."
        doc.textWithLink(footerText1, footerRectagleX+10, footerRectangleY+15, {url:footerText1});
        doc.text(footerText2, footerRectagleX+420, footerRectangleY+15)

        //== logo image settings
        let logoImg = document.getElementById('logoImg');
        let logoImgOriWidth = logoImg.offsetWidth;
        let logoImgoOriHeight = logoImg.offsetHeight;

        let logoImgRatio = 37/logoImgoOriHeight;

        let logoImgWidth = logoImgOriWidth*logoImgRatio;
        let logoImgHeight = logoImgoOriHeight*logoImgRatio;
        
        //== timestamp
        doc.setFont("helvetica");
        doc.setTextColor(255,255,255);
        doc.setFontSize(12);
        let dt  = new Date();
        
        // EST
        //dt.setTime(dt.getTime()+dt.getTimezoneOffset()*60*1000);
        //let offset = -300; //Timezone offset for EST in minutes.
        //let currentdate = new Date(dt.getTime() + offset*60*1000);

        let currentdate = new Date(dt.getTime() + 60*1000);
        // if (this.hasDST(currentdate)){   //if DST (Daylight Saving time) is in effect
        //     currentdate.setHours(currentdate.getHours()+1);
        // }
        let currentMonth = currentdate.toLocaleString('default', { month: 'long' });
        currentdate.setMonth(currentdate.getMonth()+1); //since month values are 0~11
        let datetime = currentMonth + " "
        +  String(currentdate.getDate()).padStart(2, '0')  + ", " 
        +  currentdate.getFullYear() + " "  
        +  String(currentdate.getHours()).padStart(2, '0') + ":"
        +  String(currentdate.getMinutes()).padStart(2, '0') + ":"
        +  String(currentdate.getSeconds()).padStart(2, '0');
        doc.text(datetime, pageWidth - 280, rectangleY+35);

        //== main image settings
        let mapOutput = document.getElementById('map');
        let oriMapOutputWidth = mapOutput.offsetWidth;
        let oriMapOutputHeight = mapOutput.offsetHeight;
        console.log (oriMapOutputWidth);
        console.log (oriMapOutputHeight);
        //mapOutput.style.width = "1000px";
        //mapOutput.style.height = "560px";
        let oriWidth = mapOutput.offsetWidth;
        let oriHeight = mapOutput.offsetHeight;
        let pdfRatio = maxWidth/oriWidth;    //1000px is target width
        if(oriHeight*pdfRatio > maxHeight){
            pdfRatio = maxHeight/oriHeight;
        }
        let mapOutputClone = mapOutput.cloneNode(true);
        // mapOutputClone.style.width = "1000px";
        // mapOutputClone.style.height = "560px";
        //document.body.appendChild(mapOutputClone);
        var imgWidth = oriWidth*pdfRatio;
        var imgHeight = oriHeight*pdfRatio;
        // imgWidth = 1000;
        // imgHeight = 560;
        
        // get left top xy position to put image at center
        const marginX = (pageWidth - imgWidth) / 2;
        console.log (rectangleY);
        console.log (descRectangleY);

        //const marginY = ((pageHeight - imgHeight) / 2)+descRectangleY+descRectangleHeight-(pageHeight-footerRectangleY);
        const marginY = ((pageHeight - imgHeight) / 2)+rectangleHeight+16+(gap*3);

        //== add images
        htmlToImage.toPng(logoImg, {canvasWidth: logoImgWidth, canvasHeight: logoImgHeight, backgroundColor: "#193446"})
        .then(function (dataUrl) {
            var img = new Image();
            img.src = dataUrl;
            doc.addImage(img, 'PNG', rectangleX+5, rectangleY+4, logoImgWidth, logoImgHeight);
        })
        .catch(function (error) {
            console.error('oops, something went wrong!', error);
        });
        
        // htmlToImage.toPng(mapOutput, {canvasWidth: imgWidth, canvasHeight: imgHeight, filter: this.filterElement })
        htmlToImage.toPng(mapOutput, {canvasWidth: imgWidth, canvasHeight: imgHeight })
        .then(function (dataUrl) {
            console.log ("imgWidth:" + imgWidth);
            console.log ("imgHeight:" + imgHeight);
            var img = new Image();
            img.src = dataUrl;
            doc.addImage(img, 'PNG', marginX, marginY, imgWidth, imgHeight);
            doc.save('Coastal Planner Output.pdf');
            //mapOutputClone.parentNode.removeChild(mapOutputClone);
            
            //mapOutput.style.width = oriMapOutputWidth +"px";
            //mapOutput.style.height = oriMapOutputHeight +"px";
        })
        .catch(function (error) {
            console.error('oops, something went wrong!', error);
        });
        
        // font
        // Courier: (4) ['', 'Bold', 'Oblique', 'BoldOblique']
        // Helvetica: (4) ['', 'Bold', 'Oblique', 'BoldOblique']
        // Symbol: ['']
        // Times: (4) ['Roman', 'Bold', 'Italic', 'BoldItalic']
        // ZapfDingbats: ['']
        // courier: (4) ['normal', 'bold', 'italic', 'bolditalic']
        // helvetica: (4) ['normal', 'bold', 'italic', 'bolditalic']
        // symbol: ['normal']
        // times: (4) ['normal', 'bold', 'italic', 'bolditalic']
        // zapfdingbats: ['normal']
        
    }
}

export { AppHandler as default };