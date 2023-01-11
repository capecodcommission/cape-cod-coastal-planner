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
        let rectangleHeight = 53;
        let rectangleX = (pageWidth - maxWidth) / 2;
        let rectangleY = 70;
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
        let footerText1 = "www.capecodcoast.org";
        let footerText2 = "Funded by a NOAA Coastal Resilience Grant awarded to the Cape Cod Commission and partner agencies."
        doc.textWithLink(footerText1, footerRectagleX+10, footerRectangleY+15, {url:footerText1});
        doc.text(footerText2, footerRectagleX+420, footerRectangleY+15)

        //== logo image settings
        
         let logoImg = "data:image/png;base64,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OnhtcHRrPSJYTVAgQ29yZSA0LjQuMC1FeGl2MiI+CiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICB4bWxuczppcHRjRXh0PSJodHRwOi8vaXB0Yy5vcmcvc3RkL0lwdGM0eG1wRXh0LzIwMDgtMDItMjkvIgogICAgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iCiAgICB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIgogICAgeG1sbnM6cGx1cz0iaHR0cDovL25zLnVzZXBsdXMub3JnL2xkZi94bXAvMS4wLyIKICAgIHhtbG5zOkdJTVA9Imh0dHA6Ly93d3cuZ2ltcC5vcmcveG1wLyIKICAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIgogICB4bXBNTTpEb2N1bWVudElEPSJnaW1wOmRvY2lkOmdpbXA6Mzc3Y2QwYjQtY2FhZS00YWU0LTljOWEtN2E2MGFkM2EwN2ZkIgogICB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjU2NmRhNGY5LTIxMzQtNDYyOC1iN2Y2LWMwYjE0ZDliOGVjNiIKICAgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOmJiNDE1YzhjLTlhYjAtNGZhYS04ZjU3LTJjNTI4YTNkNjQ3NyIKICAgR0lNUDpBUEk9IjIuMCIKICAgR0lNUDpQbGF0Zm9ybT0iV2luZG93cyIKICAgR0lNUDpUaW1lU3RhbXA9IjE2NjQ1NTQyNjIyMzU5ODkiCiAgIEdJTVA6VmVyc2lvbj0iMi4xMC4yMiIKICAgZGM6Rm9ybWF0PSJpbWFnZS9wbmciCiAgIHRpZmY6T3JpZW50YXRpb249IjEiCiAgIHhtcDpDcmVhdG9yVG9vbD0iR0lNUCAyLjEwIj4KICAgPGlwdGNFeHQ6TG9jYXRpb25DcmVhdGVkPgogICAgPHJkZjpCYWcvPgogICA8L2lwdGNFeHQ6TG9jYXRpb25DcmVhdGVkPgogICA8aXB0Y0V4dDpMb2NhdGlvblNob3duPgogICAgPHJkZjpCYWcvPgogICA8L2lwdGNFeHQ6TG9jYXRpb25TaG93bj4KICAgPGlwdGNFeHQ6QXJ0d29ya09yT2JqZWN0PgogICAgPHJkZjpCYWcvPgogICA8L2lwdGNFeHQ6QXJ0d29ya09yT2JqZWN0PgogICA8aXB0Y0V4dDpSZWdpc3RyeUlkPgogICAgPHJkZjpCYWcvPgogICA8L2lwdGNFeHQ6UmVnaXN0cnlJZD4KICAgPHhtcE1NOkhpc3Rvcnk+CiAgICA8cmRmOlNlcT4KICAgICA8cmRmOmxpCiAgICAgIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiCiAgICAgIHN0RXZ0OmNoYW5nZWQ9Ii8iCiAgICAgIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6NmFiNzk4YmEtZmMwZS00NjBkLTg4YWEtNDJjZDA5MTQwYjdlIgogICAgICBzdEV2dDpzb2Z0d2FyZUFnZW50PSJHaW1wIDIuMTAgKFdpbmRvd3MpIgogICAgICBzdEV2dDp3aGVuPSIyMDIyLTA5LTMwVDEyOjExOjAyIi8+CiAgICA8L3JkZjpTZXE+CiAgIDwveG1wTU06SGlzdG9yeT4KICAgPHBsdXM6SW1hZ2VTdXBwbGllcj4KICAgIDxyZGY6U2VxLz4KICAgPC9wbHVzOkltYWdlU3VwcGxpZXI+CiAgIDxwbHVzOkltYWdlQ3JlYXRvcj4KICAgIDxyZGY6U2VxLz4KICAgPC9wbHVzOkltYWdlQ3JlYXRvcj4KICAgPHBsdXM6Q29weXJpZ2h0T3duZXI+CiAgICA8cmRmOlNlcS8+CiAgIDwvcGx1czpDb3B5cmlnaHRPd25lcj4KICAgPHBsdXM6TGljZW5zb3I+CiAgICA8cmRmOlNlcS8+CiAgIDwvcGx1czpMaWNlbnNvcj4KICA8L3JkZjpEZXNjcmlwdGlvbj4KIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAKPD94cGFja2V0IGVuZD0idyI/Pkog56EAAAAGYktHRAAdAFQAl2TtaMcAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAHdElNRQfmCR4QCwKgwwt1AAAdRklEQVR42u2dd3hUVdrAf3f6TGYmvRdCCAmEUCT0FgjSi4KiYFsXkF1RVhTcXSuuba3YWAVUFBUQCwhKb6FDKAFCCwESCOl1ZtKmf38EB0LaJKB++3339zzz8HDvPeee3Hvec973Pe97rhDcY7gTERGR/1dIxEcgIiIKvoiIiCj4IiIi/xeR3WwFUqUClZcebaAfutAgtIF+yNQqpEoFEqkUQRBw2O04rFZsNWaqS42YcvIw5RVRXVKGtboap0N0M4iI/FcIvlSpIDA+loDOHVB6apHIZAiCUHtOEPBQyFFKa49Z7XaqrFbMKhUqL0+8o8Jx2O3YasyUXcwmJ+UYNWUG8W2IiPxOCC316it0HvjHtScgPha1tycSQSBQ60G0jw/RPt5EeOrx99CglsmQS6UA2B1OzHYb5TU15BhNXCwrJ6OklEvlBsx2O3aLlZKMTPKPnaayoEjUAERE/tcIviCgCw4gZuxQlHotEkEgVK9jcnwc3YODXELuLk6nkxyTie9PnuFATg52hxOnw0H2/qPkHDyG0+EQ346IyB8p+BKplPABPQnqFodULqO9jzd3doylS2AAarn8phpgdzjINhrZkHGB5KzL2Ox2jFfyyNy2j6riUvENiYj8EYIv99AQNXwAvu0iUclkjIxux6ROHVHKpLe0IU6nk9T8Ar44epy8igospkrSf96KKa8QnKLqLyJyK5HqQtq91NRMHzvudnyiIvBWq5jd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";
         let logoImgWidth = 254;
         let logoImgHeight = 51;
        //== timestamp
        doc.setFont("helvetica");
        doc.setTextColor(255,255,255);
        doc.setFontSize(12);
        let dt  = new Date();
        
        // EST

        let currentdate = new Date(dt.getTime() + 60*1000);
        let currentYear = currentdate.getFullYear();
        let currentMonth = currentdate.toLocaleString('default', { month: 'long' });
        currentdate.setMonth(currentdate.getMonth()+1); //since month values are 0~11
        let datetime = currentMonth + " "
        +  String(currentdate.getDate()).padStart(2, '0')  + ", " 
        +  currentYear + " "  
        +  String(currentdate.getHours()).padStart(2, '0') + ":"
        +  String(currentdate.getMinutes()).padStart(2, '0') + ":"
        +  String(currentdate.getSeconds()).padStart(2, '0');
        doc.text(datetime, pageWidth - 280, rectangleY+35);

        //== main image settings
        let mapOutput = document.getElementById('map');
        let oriMapOutputWidth = mapOutput.offsetWidth;
        let oriMapOutputHeight = mapOutput.offsetHeight;
        
        let oriWidth = mapOutput.offsetWidth;
        let oriHeight = mapOutput.offsetHeight;
        let pdfRatio = maxWidth/oriWidth;    //1000px is target width
        if(oriHeight*pdfRatio > maxHeight){
            pdfRatio = maxHeight/oriHeight;
        }
        let mapOutputClone = mapOutput.cloneNode(true);
        var imgWidth = oriWidth*pdfRatio;
        var imgHeight = oriHeight*pdfRatio;
        // get left top xy position to put image at center
        const marginX = (pageWidth - imgWidth) / 2;

        const marginY = ((pageHeight - imgHeight) / 2)+rectangleHeight+6+(gap*3);

        doc.addImage(logoImg, 'PNG', rectangleX+5, rectangleY+2, logoImgWidth, logoImgHeight);
        
        htmlToImage.toPng(mapOutput, {canvasWidth: imgWidth, canvasHeight: imgHeight })
        .then(function (dataUrl) {
            var img = new Image();
            img.src = dataUrl;
            doc.addImage(img, 'PNG', marginX, marginY, imgWidth, imgHeight);
            doc.save('Coastal Planner Output.pdf');
        })
        .catch(function (error) {
            console.error('oops, something went wrong!', error);
        });
        
        
    }
}

export { AppHandler as default };