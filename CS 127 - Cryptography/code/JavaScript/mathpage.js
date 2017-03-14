// MathPage JavaScript 2.0: "MathPage JavaScript", "MathPage JavaScript v2.0 (MathType 5.2) by Design Science, Inc."
// Copyright 2001-2011 Design Science, Inc.
// $Header: //depot/release/MathType/6.7eMac/MathType/MathPage/pub/MathPage.js#1 $

//<script> for MSVI color-coding

var DSMP = { // place all globals in DSMP object to limit global namespace conflicts

// BEGIN PUBLIC/EXPORTED GLOBALS (referenced in generated HTML)

// detecting existence of this JS file
gJSFound : true, // typeof object == undefined if this JS file is not found

// global settings overridden in generated HTML
gPageVersion	: 0, // page version checked against version of this javascript file
gMaxCharCompat : 0, // integer: 0=all browsers, 1=IE5+/Win, 2=IE5+/Mac
gGenMathZoom	: 1, // integer: 0=no or 1=yes
gPopupEqnBgColorDefault: "", // default MathZoom background color
gPopupEqnPaddingDefault: 10, // default padding around MathZoom equation inside of border
gPlaceholderPadding : 4, // extra padding pixels around placeholder

// messages are all set in the HTML for possible localization or registry override
gOldJSMessage		: "",
gCompatMessage		: "",
gMinBrowserMessage: "",
gHidePopupMessage	: "",
gShowPopupMessage	: "",

// Equation parameters used as JavaScript entities (NN) in snippets
gPlaceholderWidth  :0,	// placeholder width in pixels
gPlaceholderHeight :0,	// placeholder height (above the baseline) in pixels
gPlaceholder2Height:0,	// 2nd placeholder height (for pushing next line down) in pixels
gScreenEqnWidth    :0,	// screen equation width in pixels
gScreenEqnHeight   :0,	// screen equation height in pixels
gScreenEqnSrc      :"",	// the relative URL to the screen GIF
gPrintEqnSrc       :"",	// the relative URL to the print GIF
gPopupEqnSrc       :"",	// the relative URL to the popup GIF
gEmptySrc          :"",	// the relative URL to the empty GIF
gPopupEqnPadding   :0,	// how many pixels of padding to add around a popup
gNNPopupBgColor    :"",	// set to custom bg color or default of light-yellow; NN4.x-only
gNNLayerTop        :0,	// top coordinate to display equation; NN4.x-only
gNNLayerLeft       :0,	// left coordinate to display equation; NN4.x-only

// END PUBLIC/EXPORTED GLOBALS

// BEGIN PRIVATE GLOBALS (not referenced in HTML, only in this JS file)

gJSVersion: "2.0", // major.minor version number of this file
gSupportFolder: "", // the supporting files folder containing the GIFs

// browser functionality flags
gIsNN4               : false, // true if NN4.x only
gIsIE5Win            : false, // for checking against document generation mode; true if IE5+/Win only
gIsIE5Mac            : false, // for checking against document generation mode; true if IE5+/Mac only
gPopupEqnSpan        : false, // generate SPAN for popups; Win IE only
gDeleteNNObjects     : false, // delete NN4.x code; true for most version 5+ browsers
gDeleteScriptBlocks  : false, // delete SCRIPT blocks; Win IE only to fix extra space around eqns when printing
gAddMargins          : false, // account for BODY margins when calulating doc positions; Mac IE5+ and Safari v125+ only
gPrint72DPI          : false, // use 72dpi GIF dimensions when printing; Mac IE5+ only
gSpanWidth1px			: false, // width 1px needed to get span to match img in sub/sup; Mac IE5.0 and Win IE4 only
gFixEquationPositions: false, // fix equations to be positioned relative to span height instead of line height; Mac IE5.1+ only
gFixPopupsInTables   : false, // must calculate document coordinates for popups in tables; Mac IE5.1+ only
gPrint96DPI          : false, // use 96dpi GIF dimensions when printing; Win IE5.5 only
gPrint72DpiGIF       : false, // use 72dpi GIF when printing; Mac NN only
gAdjPopupTopLeft     : false, // adjust popup top by pixelTop of equation; Mac IE only
gDOM1                : false, // browser supports standard DOM1 access to document nodes
gFontSize1px         : false, // use font-size:1px for height of placeholder SPAN
gRestoreLineSpacing  : false, // push lines further apart if line spacing > eqn height; Win IE5+ only
gAlignSubSup         : false, // use special alignment of sub/super placeholder in Win IE4 and 5.0 only
gIgnorePopupTopInTables: false, // negative top values OK for popups in tables; Mac IE4.5 only
gHidePopupsOnPrint   : false, // extra stylesheet rule needed to collapse space of popups; Mac IE4.5 only
gScaleUpTEFonts      : false, // scale up font sizes for techexplorer on Mac IE and NN only
gRelativePositioning : false, // use relative positioning if absolute positioning within SPAN is broken
gCalcDPIInNewWindow  : false, // calculate the screen DPI in a separate window
gIgnoreMouseButton	: false, // ignore which mouse button clicked on Safari
gUseEquationOffsets	: false, // include equation offsets in calculating position of equation; Mozilla only
gPrintRelative       : false, // use relative positioning on print

// screen and print DPI variables
gDpi : 0, // browser's current rendering DPI
gDpiIdx : 0, // index into eqnArray and gDpiSuffix arrays
gDpiRatio : 1, // screen-to-print ratio used for NN4.x printing
gDpiSuffix : new Array("S","M","L"), // file suffixes corresponding to 72, 96, and 120 dpi screen resolutions

gEqnID : "", // the equation or symbol filename prefix, e.g. eq0001 or ch0001

// add'l screen equation dimensions in pixels
gScreenEqnBaseline:0, gScreenEqnLeftBearing:0, gScreenEqnRightBearing:0,

// print equation dimensions in pixels, different than screen equation dimensions for IE5.5/Win and IE5/Mac
gPrintEqnWidth:0, gPrintEqnHeight:0, gPrintEqnBaseline:0, gPrintEqnLeftBearing:0, gPrintEqnRightBearing:0,

// print placeholder dimensions in pixels
gPrintPlaceholderWidth:0, gPrintPlaceholderHeight:0,

// add'l popup equation settings
gPopupEqnBgColor:0, // custom background color to use for the popup
gPopupEqnAddPadding:false, // whether to add padding to the popup
gPopupEqnAddBorder:false, // whether to add a border to the popup

// array of open (visible) popups - used to close all quickly
gOpenPopups: new Array() 

// END PRIVATE GLOBALS

};

// this is the only function to be called by global code
MPHeadInit();

// perform initialization and any tasks needed in the <HEAD> of the document
function MPHeadInit() {
with (DSMP) {
	// detect browser version
	// default to latest known version of each browser
	if (navigator.appName=="Netscape") {
		if (navigator.appVersion.indexOf("Safari") != -1) {
			// Apple Safari
			var safariVer = 0;
			var start = navigator.userAgent.indexOf("Safari/");
			if (start != -1) {
				safariVer = parseInt(navigator.userAgent.substring(start+7));
			}
			gDeleteNNObjects = true;
			gDOM1 = true;
			gIgnoreMouseButton = true;
			if ( safariVer < 125 ) {
				gFixEquationPositions = true;			
				gPrintRelative = true;			
				window.onload = MPRepositionAllEquations;
			} else {
				gFontSize1px=true;
				gUseEquationOffsets = true;
				gAddMargins = true;
				window.onload = MPRepaintWindow;
			}
		} else if (navigator.appVersion >= "5") {
			// N6/mozilla engine
			gDeleteNNObjects = true;
			gDOM1 = true;
			gCalcDPIInNewWindow = false;
			gUseEquationOffsets = true;
			gFontSize1px = true;
			if (navigator.appVersion.indexOf("Macintosh") != -1) {
				gPrintRelative = true;			
			}
		} else {			
			// Netscape Navigator 4.x
			gIsNN4 = true;
			window.captureEvents(Event.RESIZE);
			if (navigator.appVersion.indexOf("Macintosh") != -1) {
				gPrint72DpiGIF = true; // Mac NN must print 72 dpi GIF - does not scale down large GIFs
				gScaleUpTEFonts = true;	// scale up font sizes for techexplorer on Mac		
			}
			if (navigator.appVersion < "4") {
				alert(gMinBrowserMessage);
			}
		}
	} else if (navigator.appName=="Microsoft Internet Explorer") {		
		// Microsoft Internet Explorer
		// extract IE version number
		// must use userAgent because appVersion does not reflect actual version number on Mac IE 5.x
		var ieVer = 0;
		var start = navigator.userAgent.indexOf("MSIE ");
		if (start != -1) {
			ieVer = parseFloat(navigator.userAgent.substring(start+5));
		}
		if (ieVer < 4) {
			alert(gMinBrowserMessage);
		}

		if (navigator.appVersion.indexOf("Windows") != -1) {
			// Windows IE browsers
			gPopupEqnSpan = true;
			if (ieVer >= 5.5) {
				// Windows IE5.5 or later
				gIsIE5Win = true;
				gDeleteNNObjects = true;
				gDeleteScriptBlocks = true;
				gRestoreLineSpacing = true;
				gPrint96DPI = true; // must print using 96dpi sizes
			} else if (ieVer >= 5.0) {
				// Windows IE5
				gIsIE5Win = true;
				gDeleteNNObjects = true;
				gDeleteScriptBlocks = true;
				gRestoreLineSpacing = true;
				gAlignSubSup = true; 
			} else {
				// Windows IE4 or earlier
				// can't DeleteNNObjects, gives error 8000000a
				//gDeleteNNObjects = true;
				gAlignSubSup = true;
				gSpanWidth1px = true; 
			}
		} else if (navigator.appVersion.indexOf("Macintosh") != -1) {
			// Mac IE browsers
			gAdjPopupTopLeft = true; // must adjust popup top in all versions of Mac IE
			gPopupEqnSpan = false;
			gScaleUpTEFonts = true; // scale up font sizes for techexplorer on Mac			
			if (ieVer >= 5.1) {
				gIsIE5Mac = true;
				gAddMargins = true; // must account for BODY margins
				gPrint72DPI = true; // must print using 72dpi sizes
				gIgnorePopupTopInTables = true; // negative top values OK for popups in tables in Mac IE 4.5
				gDeleteNNObjects = true;
				gFixEquationPositions = true;
				gFixPopupsInTables = true;
				gPrintRelative = true;
				window.onload = MPRepositionAllEquations;
			} else if (ieVer == 5.0) {
				// Mac IE 5.0 only
				gIsIE5Mac = true;
				gAddMargins = true; // must account for BODY margins
				gPrint72DPI = true; // must print using 72dpi sizes
				gDeleteNNObjects = true;
				gSpanWidth1px = true; // width 1px needed to get span to match img in sub/sup
			} else {
				// Mac IE4.5 or earlier 
				gPopupEqnPadding = 0; // no need to account for padding in popups when positioning in Mac IE4.5
				gIgnorePopupTopInTables = true; // negative top values OK for popups in tables in Mac IE 4.5
				gHidePopupsOnPrint = true; // extra stylesheet rule needed to collapse space of popups
			}
		}
	} else if (navigator.appName=="Opera") {
		// Opera
		gDeleteNNObjects = true;
		gDOM1 = true;
		gRelativePositioning = true;
		gPrintRelative = true;
	}

	// install onResize handler
	window.onresize = MPOnResize;

	// generate any necessary style sheet overrides
	MPGenStyleSheets();
}
}

// write out style sheets
function MPGenStyleSheets() {
with (DSMP) {
	if (gIsNN4) return;
	
	var s = "";

	// styles for both screen and print
	s += "<style> \n" +
	 ".MPNNCode { display:none } \n" +
	 "sub,sup { font-size:.7em } \n";	

	if (gHidePopupsOnPrint) {
		// extra stylesheet rule needed to collapse space of popups on Mac IE4.5
		s += ".MPPopup,.MPPopupNoBg { position:absolute; visibility:hidden } \n" +
		 "table { z-index:98 } \n";
	}	
	
	if (gRelativePositioning) {
		s += ".MPScreenEqn { position:relative } \n" +
			".MPPrintEqn { position:relative } \n";
	}

	if (gFixEquationPositions) {
		s += ".MPScreenEqn { visibility:hidden } \n";
	}

	s += "</style> \n";
	
	if (gPrintRelative) {
		s += "<style media=print> \n" +
			".MPPrintEqn { position:relative } \n" +
			".MPPHSpan,.MPScreenPH,.MPScreenEqn,.MPPopup,.MPPopupNoBg,.MPPH { display:none } \n" +
			"</style> \n";
	}
	
	document.write(s);
}
}

// MPOnResize - reload page for NN4.x, otherwise simple hide popups
// NN4.x resize is buggy - must reload document
// onresize event is fired when user resizes window or changes font size
function MPOnResize() {
with (DSMP) {
//alert("MPOnResize");
	if (gIsNN4) {
		if (navigator.appVersion.substr(0,4) != "4.05")	// TODO: NN4.05 will loop indefinitely if window needs scrollbars
			location.reload();
	} else {
		MPHideAllPopups();
		if (gFixEquationPositions) {
			MPRepositionAllEquations();
		}
	}
}
}
// MPRepaintWindow - force a repaint of the window by resizing temporarily
// used to fix Safar v1.2 painting bug
function MPRepaintWindow() {
	window.resizeBy(1,1);
	window.resizeBy(-1,-1);
}

// MPRepositionAllEquations - reposition all equations based on their placeholder positions
// used by Mac IE5.1+ and Safari because CSS absolute positioning within SPAN is broken
function MPRepositionAllEquations() {
with (DSMP) {
	for (var i=0; i<document.images.length; i++) {
		var id = (gDOM1 ? document.images.item(i).id : document.images[i].id);
		var prefix = id.substr(0,2);
		// equations (eq####) and symbols (ch####)
		if (id.length==6 && (prefix=="ch" || prefix=="eq")) {
			MPRepositionEquation(id);
		}
	}
}
}

// check page version settings and calculate screen dpi
function MPBodyInit(supportFolder) {
with (DSMP) {
	// check if the major version required by the page is higher than this javascript's major version
	if (parseInt(gPageVersion) > parseInt(gJSVersion)) {
		alert(gOldJSMessage);
	}
	
	// check if the document was optimized for IE5+/Win
	if (gMaxCharCompat == 0) { // IE/Win
		if (!gIsIE5Win) 
			alert(gCompatMessage);
	} 
	else if (gMaxCharCompat == 2) { // IE/Mac
		if (!gIsIE5Mac) 
			alert(gCompatMessage);
	} 
	
	// escape the supporting files folder name and append a slash
	gSupportFolder = escape(supportFolder);
	if (gSupportFolder.length > 0) {
		gSupportFolder += "/";
	}
	
	// calculate effective screen dpi
	MPCalcDPI();
}
}

function MPCalcDPI() {
with (DSMP) {
	// gDpi is browser's current rendering DPI
	if (gIsNN4) {
		gDpi = eval("document.layers.MPDpiSpan.top");
		// gDpiRatio is the ratio of the browser's rendering DPI to its coordinate system
		// e.g. when printing, we set an x position to 20 and NN returns an x of 200, so the ratio would be 10
		// typically, the on-screen ratio is 1.
		gDpiRatio = eval("document.layers.MPDpiSpan.clip.width") / 100;
	} else if (gDOM1) {
		if (gCalcDPIInNewWindow) {
			// put up temporary window to calculate dpi if MPDpiSpan does not reflect proper TOP value
			var w = window.open();
			w.document.write("<span id=MPDpiSpan style='position:absolute;top:1in'>ABC</span>");
			w.document.close();
			gDpi = w.document.getElementById("MPDpiSpan").offsetTop;
			w.close();
		} else {
			gDpi = document.getElementById("MPDpiSpan").offsetTop;
		}
	} else {
		gDpi = eval("document.all.MPDpiSpan.offsetTop"); // IE
		if (gAddMargins) {
			gDpi += document.body.topMargin;
		}
	}
		
	// gDpiIdx indexes the eqnArray and gDpiSuffix arrays and says whether we use 72, 96, or 120 dpi GIFs.
	if (gDpi >= 108)
		gDpiIdx = 2; // 120 dpi
	else if (gDpi >= 84)
		gDpiIdx = 1; // 96 dpi
	else	
		gDpiIdx = 0; // 72 dpi
//DEBUG: uncomment the following line to see the effective screen dpi
//alert("dpi="+gDpi);		
}
}

// Delete a node out of the document tree
function MPDeleteNode(id) {
with (DSMP) {
	if (gDOM1) {
 		var node = document.getElementById(id);
		if (node != null) {
			node.parentNode.removeChild(node);
		}
	} else {
		if (typeof document.all[id].length == "number") {
			// first delete duplicate nodes with same id that cause an array to be created
			for (var i=document.all[id].length-1; i>0; --i) {
				document.all[id][i].outerHTML="";
			}
		} 
		document.all[id].outerHTML="";
	}
}
}

function MPDeleteCode(id) {
with (DSMP) {
	// delete Netscape code and script blocks
	if (gDeleteNNObjects) {
		MPDeleteNode("mpnn" + id + "ph"); // placeholder code
		MPDeleteNode("mpnn" + id);			// equation code
	}
	if (gDeleteScriptBlocks) {
		MPDeleteNode("mp" + id + "s1");
		MPDeleteNode("mp" + id + "s2");
//		MPDeleteNode("mp" + id + "s3"); // can't delete calling script block, might crash IE5
	}
}
}

// write out the HTML for an inline equation or math character (except NN4)
function MPWriteEqn(doPopup, inSubSup) {
with (DSMP) {
	// HTML ID attributes
	var eqnId   = gEqnID;
	var phId    = gEqnID + "ph";
	var popupId = gEqnID + "pop";
	var prtId   = gEqnID + "prt";
	var s = "";
	var styleStr="";

	// create HTML for popup
	if (doPopup) {
		if (gPopupEqnSpan) {
			s += "<span ";
		} else {
			s += "<img border=0 ";
		}
		if (gPopupEqnBgColor) {
			s += "class=MPPopupNoBg";
			styleStr += "background-color:#" + gPopupEqnBgColor + ";";
		} else {
			s += "class=MPPopup";
		}
		if (!gPopupEqnAddBorder) {
			styleStr += "border:none;";
		}
		if (!gPopupEqnAddPadding) {
			styleStr += "padding:0px;";
		}
		if (gPopupEqnSpan) {
			styleStr += "width:" + gPopupEqnWidth + "px;height:" + gPopupEqnHeight + "px";
		}
		if (styleStr.length > 0) {
			s += " style='" + styleStr + "'";
		}
		s += " id=" + popupId;
		if (gPopupEqnSpan) {
			s += "><img border=0 ";
		}
		s += " src='" + gPopupEqnSrc + "'" +
			" width=" + gPopupEqnWidth +
			" height=" + gPopupEqnHeight +
			" onmousemove='status=" + '"' + gHidePopupMessage + '"' + "'" +
			" onmouseover='status=" + '"' + gHidePopupMessage + '"' + "'" +
			" onmouseout='status=" + '""' + "'" + 
			" onclick='return MPHidePopup(event," + popupId + ")'>";
		if (gPopupEqnSpan) {
			s += "</span>"; 
		}
	}

	// prevent line breaks between placeholder GIFs
	s += "<nobr>";	
	
	// create HTML for screen and print equations
	// position equation absolutely within a span's relative coordinates to an empty GIF placeholder
	var top = gPlaceholderPadding;
	var left = -gScreenEqnLeftBearing;
	var phWidth = gPlaceholderWidth - (gRestoreLineSpacing ? 3 : 1); // allow for add'l 1-3 placeholders

	// opening SPAN and placeholder GIF(s)
	if (gRelativePositioning) {
		// use relative positioning of screen and print equations
		// no SPAN or placeholder - do nothing here
		;
	} else if (gAlignSubSup && inSubSup) {
		// in IE4/5/Win, if in a subscript or superscript, must use special alignments on placeholder
		phWidth = gPlaceholderWidth; // no 2nd placeholder for linespacing
		if (inSubSup==2) { // superscript
			s += "<span id=" + phId + "span class=MPPHSpan style='position:relative;width:1px;height:" + gPlaceholderHeight + "px'>";
			top = -gPlaceholderHeight;
		} else { // subscript
			s += "<span id=" + phId + "span class=MPPHSpan style='position:relative;width:1px;height:1px'>";
		}
		s += "<img class=MPPH src='" + gEmptySrc + "'" +
			" id=" + phId +
			" width=" + gPlaceholderWidth +
			" height=1";
		if (inSubSup==2) { // superscript			
			s += " align=middle border=0";
		} else {
			s += " align=baseline style='position:relative;top:1ex' border=0";
			top = 1;
		}
		s += ">";
	} else if (gPrint72DPI || gPrint96DPI) {
		// mac ie5.0+ requires use of 72dpi dimensions for printing, and
		// win ie5.5+ requires use of 96dpi dimensions for printing,
		// so use two separate placeholders for screen and print.

		// SPAN for positioning of equation:
		s += "<span id=" + phId + "span class=MPPHSpan style='position:relative";
		
		if (gSpanWidth1px) 
			s += ";width:1px"; // width 1px needed to get span to match img in sub/sup (mac ie5.0 only)
		else if (gPrint96DPI) 
			s += ";height:1px;font-size:0px'";
			
		s += "'>";
		// Separate placeholders for screen and print
		s +=	"<img class=MPScreenPH src='" + gEmptySrc + "'" +
			" id=" + phId +
			" width=" + phWidth +
			" height=" + gPlaceholderHeight +
			"><img class=MPPrintPH src='" + gEmptySrc + "'" +
			" id=" + phId + "prt" +
			" width=" + ( gPrintPlaceholderWidth - (gRestoreLineSpacing ? 3 : 1) ) +
			" height=" + gPlaceholderHeight +
			">";
	} else if (gFontSize1px) {
		// Mozilla and Safari v1.2+ SPANs do not reflect height of children. 
		// use font-size:1px and negative top value
		s += "<span id=" + phId + "span class=MPPHSpan style='position:relative;font-size:1px'>";
		top += (-gPlaceholderHeight + 1);
		// placeholder
		s += "<img class=MPPH src='" + gEmptySrc + "'" +
			" style='visibility:visible' " + // make visible as temporary fix for detecting clicks above baseline
			" id=" + phId +
			" width=" + phWidth +
			" height=" + gPlaceholderHeight +
			">";
	} else {
		// normal case - one placeholder for both screen and print
		s += "<span id=" + phId + "span class=MPPHSpan style='position:relative;height:" + gPlaceholderHeight + "px";
		if (gSpanWidth1px) s += ";width:1px"; // width:1px needed by IE4 
		s += "'>";
		// placeholder
		s += "<img class=MPPH src='" + gEmptySrc + "'" +
			" align=baseline" +
			" id=" + phId +
			" width=" + phWidth +
			" height=" + gPlaceholderHeight +
			">";
	}

	// screen equation
	if (gRelativePositioning) {
		top = gScreenEqnBaseline;
	} 
	s += "<img class=MPScreenEqn" +
		" align=baseline " +
		" id=" + eqnId +
		" border=0 style='z-index:98;cursor:";
	if (doPopup) {
		s += "hand";
	} else {
		s += "default";
	}
	s += ";top:" + top + "px;" +
		"left:" + left + "px'" +
		" src='" + gScreenEqnSrc + "'" +
		" width=" + gScreenEqnWidth +
		" height=" + gScreenEqnHeight;
	if (doPopup) {
		// must use onclick not onmousedown so that drag-and-drop will still work in IE/Win
		s += " onclick='return MPShowPopup(" + eqnId + "," + popupId + ",event)'" +
			" onmousemove='status=" + '"' + gShowPopupMessage + '"' + "'" +
			" onmouseover='status=" + '"' + gShowPopupMessage + '"' + "'" +
			" onmouseout='status=" + '""' + "'"; 
	}
	s += ">";

	// print equation
	if (gPrint72DPI) { // Mac IE5 only
		left = -1 - gPrintEqnLeftBearing;
	}
	if (gRelativePositioning || gPrintRelative) {
		top = gPrintEqnBaseline;
	}
	var printEqnHTML = "<img class=MPPrintEqn" +
		" id=" + prtId +
		" src='" + gPrintEqnSrc + "'" +
		" style='top:" + top + "px;left:" + left + "px'" +
		" width=" + gPrintEqnWidth +
		" height=" + gPrintEqnHeight +
		">";

	if (!gPrintRelative)
		s += printEqnHTML;
		
	if (!gRelativePositioning) 
		s += "</span>";

	// the 2nd placeholder is for pushing the next line down enough to fit equation -- "At Least" line spacing
	if (!gAlignSubSup || !inSubSup) {
		s += "<img align=top class=MPPH id="+phId+"2 border=0 src='" + gEmptySrc + "'";
		s += " width=1 height=" + (gPlaceholder2Height) + ">";
	}

	// IE/Windows line spacing fix
	// push lines further apart if line spacing > eqn height
	if (gRestoreLineSpacing) {
//DEBUG: un-comment the following line to see actual dynamic HTML that is written to the document
//alert(s);	
		// first, write out equation HTML so we can get lineHeight
		document.write(s); // write out the 1st placeholder and equations: popup, screen, and print.
		s = "";
		var phObj = eval("document.all."+phId);
		var lineHeightStr = phObj.currentStyle.lineHeight;
		var lineHeight=0, ascendHeight=1, descendHeight=1;
		if (lineHeightStr != "normal") {
			lineHeight = (parseInt(lineHeightStr) * gDpi) / 72; // convert from points to pixels
			ascendHeight = parseInt(lineHeight * 3/5 + 0.5); // rough estimate
			descendHeight = parseInt(ascendHeight + (lineHeight * 1/3) + 0.5); // rough estimate
		}
		s += "<img class=MPPH id="+phId+"3 align=bottom border=0 width=1 src='" + gEmptySrc + "' height=" + ascendHeight + ">";
		s += "<img class=MPPH id="+phId+"4 align=top    border=0 width=1 src='" + gEmptySrc + "' height=" + descendHeight + ">";
	}

	s += "</nobr>";	
	
	if (gPrintRelative) {
		// print using relative positioning (set dynamically in MPGenStyleSheets)
		// put print equation outside of SPAN, 
		// which gets set to display:none but still interferes with IMG alignment
		s += printEqnHTML;
		// push next line down far enough to fit this equation
		s +=	"<img class=MPPrintPH src='" + gEmptySrc + "'" +
			" id=" + phId + "5 " +
			" align=top width=1" + 
			" height=" + (gPrintEqnHeight+gPrintEqnBaseline) +
			">";
	}

//DEBUG: un-comment the following line to see actual dynamic HTML that is written to the document
//alert(s);	

	document.write(s); // write out two placeholders and equations: popup, screen, and print.

	if (gFixEquationPositions) {
		// get placeholder and equation objects
		var phObj = document.getElementById(phId);
		var eqnObj = document.getElementById(eqnId);

		// store top,left offsets in equation objects for use later during onload event
		eqnObj.topOffset = gPlaceholderPadding;		
		eqnObj.leftOffset = gScreenEqnLeftBearing;		
	}

}
}

function MPRepositionEquation(eqnId)
{
	// get placeholder and equation objects
	var phObj = document.getElementById(eqnId+"ph");
	var eqnObj = document.getElementById(eqnId);

	// Mac IE5.1+ and Safari equation horizontal positioning fix
	// on Safari, placeholder can be moved any time during page layout
	// on IE5.1+, placeholder can get moved later on during TABLE layout
	// Equations in <P>aragraphs seem ok, but it doesn't hurt to reset the position
	// so reset equation left position based on placeholder left position and left bearing value
	eqnObj.style.pixelLeft = phObj.offsetLeft - eqnObj.leftOffset;

	// Mac IE5.1+ and Safari equation vertical positioning fix
	// Instead of being positioned relative to the top,left of the containing SPAN,
	// equations are positioned relative to top of line in IE5.1+ and top of paragraph in Safari
	// placeholder is in the right place, since it uses relative instead of absolute positioning
	// so add placeholder top value to equation top
	eqnObj.style.pixelTop = phObj.offsetTop + eqnObj.topOffset;
	
	// make equation visible
	eqnObj.style.visibility = "visible";
}

// write out the HTML for an equation
function MPEquation() {
with (DSMP) {
	if (!gIsNN4) {
		MPWriteEqn(gGenMathZoom, 0);
	}
}
}

// write out the HTML for an inline math character
function MPInlineChar(inSubSup) {
with (DSMP) {
	if (!gIsNN4) {
		MPWriteEqn(false, inSubSup);
	}
}
}

// Show a popup equation when the user clicks on the screen equation
function MPShowPopup(oEqn, oPopup, oEvent) {
with (DSMP) {
	// show popups on left-click only
	if (gIsNN4) {
		if (oEvent.which != 1) 
			return true;
	} else if (gDOM1) {
		if (oEvent.button!=0 && !gIgnoreMouseButton)
			return true;
	}
	var eqnSizeObj;
	var popupSizeObj;
	if (gIsNN4) {
		eqnSizeObj = oEqn.clip;
		popupSizeObj = oPopup.clip;
	} else {
		eqnSizeObj = oEqn;
		popupSizeObj = oPopup;
		if (gPopupEqnSpan) popupSizeObj = oPopup.children[0]; // <SPAN>...<A>...<IMG>
	}
	// Mac IE4.5 returns the following values as strings, so must convert to ints...
	var eqnWidth = parseInt(eqnSizeObj.width);
	var eqnHeight = parseInt(eqnSizeObj.height);
	var popWidth = parseInt(popupSizeObj.width);
	var popHeight = parseInt(popupSizeObj.height);	

	if (gIsNN4) {
		// popup width and height already include padding, border, and 3px margin on Netscape
		oPopup.x = oEqn.x + (eqnWidth)/2 - (popWidth)/2;
		var maxWidth = window.innerWidth;
		var scrollbarwidth = 15;
		if (document.width > window.innerWidth-scrollbarwidth) {
			maxWidth -= scrollbarwidth;
		}
		if (oPopup.x + popWidth > maxWidth) {
			oPopup.x = maxWidth - popWidth;
		}
		if (oPopup.x < 0) oPopup.x = 0;
		oPopup.y = oEqn.y + (eqnHeight)/2 - (popHeight)/2;
		if (oPopup.y + popHeight > document.height) {
			oPopup.y = document.height - popHeight;
		}
		if (oPopup.y < 0) oPopup.y = 0;
		oPopup.visibility = "show";
	} else if (gDOM1) { // e.g. Mozilla engine, Opera, Safari, etc.
		var top = oEqn.parentNode.offsetTop;
		if (gAddMargins) top += document.body.offsetTop;
		if (gUseEquationOffsets) top += oEqn.offsetTop;
		top += parseInt((eqnHeight)/2 - (popHeight)/2 - gPopupEqnPaddingDefault);
		if (top < 0) top = 0;
		var left = oEqn.parentNode.offsetLeft;
		if (gAddMargins) left += document.body.offsetTop;
		if (gUseEquationOffsets) left += oEqn.offsetLeft;
		left += parseInt((eqnWidth/2) - (popWidth/2) - gPopupEqnPaddingDefault);
		if (left < 0) left = 0;
		oPopup.style.top = top + "px";
		oPopup.style.left = left + "px";
		oPopup.style.visibility = "visible";
	} else { // non-NN, non-DOM browsers (IE)
		// first, get object we position to...
		var eqnPosObj = oEqn;
		if (eqnPosObj.tagName == "IMG" && eqnPosObj.parentElement.tagName=="SPAN") {
			// must use parent SPAN containing empty GIF to get screen coordinates
			eqnPosObj = eqnPosObj.parentElement;
		}
		// get the top and left values and adjust them...
		var top = eqnPosObj.offsetTop;
		var left = eqnPosObj.offsetLeft;
		if (gAdjPopupTopLeft) {	// For all Mac IE versions, must adjust top,left of popup by equation pixelTop,pixelLeft
			top += oEqn.style.pixelTop;
			left += oEqn.style.pixelLeft;
		}
		if (gAddMargins) {
			// must add left margin in Mac IE5 ...
			left += document.body.leftMargin;
			top += document.body.topMargin;
		}
		if (gFixPopupsInTables) { // Need to calculate relative to document top,left for Mac IE5.1+
			var inTable = false;
			var newTop=oEqn.clientTop, newLeft=oEqn.clientLeft;
			for (e=oEqn.parentElement; e!=null; e=e.parentElement) {
				if (e.tagName=="TD" || e.tagName=="TABLE") {
					newTop += e.clientTop;
					newLeft += e.clientLeft;
				}
				if (e.tagName=="TABLE") {
					inTable = true;
					break;
				}
			}
			if (inTable) {
				top = newTop;
				left = newLeft;
			}
		}
		// get padding value...
		var padding;
		if (oPopup.currentStyle) {
			padding = parseInt(oPopup.currentStyle.padding);
		} else {
			padding = gPopupEqnPaddingDefault; // assume this popup has default padding for IE4 or earlier...
		}
		// calculate the top value for the popup...
		oPopup.style.pixelTop = top + (eqnHeight)/2 - (popHeight)/2 - padding;
		var maxHeight = document.body.scrollHeight;
		if (document.body.offsetHeight > maxHeight) {
			maxHeight = document.body.offsetHeight;
		}
		if (oPopup.style.pixelTop + popHeight > maxHeight) {
			oPopup.style.pixelTop = maxHeight - popHeight - 2*padding - 2;
		}
		if (oPopup.style.pixelTop < 0) {
			if (gIgnorePopupTopInTables) {
				// negative top values OK for popups in tables in Mac IE 4.5
				var inTable = false;
				for (e=eqnPosObj; e!=null; e=e.parentElement) {
					if (e.tagName=="TD" || e.tagName=="TABLE") {
						inTable = true;
						break;
					}
				}
				if (!inTable) {
					oPopup.style.pixelTop = document.body.topMargin;
				}
			} else {
				oPopup.style.pixelTop = 0;
			}
		}
		// calculate the left value for the popup...
		oPopup.style.pixelLeft = left + (eqnWidth/2) - (popWidth/2) - padding;
		if ((oPopup.style.pixelLeft + popWidth) > document.body.scrollWidth) {
			oPopup.style.pixelLeft = document.body.scrollWidth - popWidth - 2*padding - 2;
		}
		if (oPopup.style.pixelLeft < 0) oPopup.style.pixelLeft = 0;
		// make the popup visible
		oPopup.style.visibility = "visible";
	}
	
	// add to gOpenPopups array to keep track of visible popups
	gOpenPopups[gOpenPopups.length] = oPopup;
	
	return false; // so that <A> link doesn't get executed
}
}

// hide all popup equations
function MPHideAllPopups() {
with (DSMP) {
	var len = gOpenPopups.length;
	for (var i=0; i<len; i++) {
		obj = gOpenPopups[i];
		if (obj != null) {
			if (gIsNN4) {
			   obj.visibility = "hide";
			} else {
			   obj.style.visibility = "hidden";
			}
		}
	}
	gOpenPopups.length = 0;
}
}

// hide a popup equation
function MPHidePopup(oEvent, oPopup) {
with (DSMP) {
   var shiftKeyPressed=false;
	// hide popups on left-click only
   if (gIsNN4) {
		if (oEvent.which != 1) return true;
		shiftKeyPressed = oEvent.modifiers & Event.SHIFT_MASK;
   } else if (gDOM1) {
		if (oEvent.button!=0 && !gIgnoreMouseButton) return true;
		shiftKeyPressed = oEvent.shiftKey;
   } else {
		shiftKeyPressed = window.event.shiftKey;
	}
   if (shiftKeyPressed) {
      MPHideAllPopups();
   } else {
      if (gIsNN4) {
         oPopup.visibility = "hide";
      } else {
         oPopup.style.visibility = "hidden";
      }
      for (var i=0; i<gOpenPopups.length; ++i) {
			if (gOpenPopups[i]==oPopup) {
				gOpenPopups[i] = null;
				break;
			}
		}
   }
   return false; // so that <A> link doesn't get executed
}
}

// set global variables used by javascript entities (NN4.x) or to document.write (all other browsers)
function MPSetAttrs(eqnStr, fileStr, doPopup, popupBgColor, eqnOptions, eqnArray) {
with (DSMP) {
	// other attributes
	gEqnID = eqnStr;
	gEmptySrc = gSupportFolder + "empty.gif";
		
	// screen attributes
	gScreenEqnWidth = eqnArray[gDpiIdx][0];
	gScreenEqnHeight = eqnArray[gDpiIdx][1];
	gScreenEqnBaseline = eqnArray[gDpiIdx][2];
	gScreenEqnLeftBearing = eqnArray[gDpiIdx][3];
	gScreenEqnRightBearing = eqnArray[gDpiIdx][4];
	if (fileStr == "ch" || fileStr == "eq") {
		gScreenEqnSrc = gEmptySrc;
	} else {
		gScreenEqnSrc = gSupportFolder + fileStr + gDpiSuffix[gDpiIdx] + ".gif";
	}	
	gPlaceholderHeight = gScreenEqnHeight - gScreenEqnBaseline + gPlaceholderPadding; // height of equation above the baseline
	gPlaceholderWidth = gScreenEqnWidth - gScreenEqnLeftBearing - gScreenEqnRightBearing;
	gPlaceholder2Height = gScreenEqnHeight + 2*gPlaceholderPadding; // 2nd placeholder is for pushing next line down

	// popup attributes
	if (doPopup) {	
		gPopupEqnWidth = eqnArray[gDpiIdx+3][0];
		gPopupEqnHeight = eqnArray[gDpiIdx+3][1];
		gPopupEqnSrc = gSupportFolder  + fileStr + gDpiSuffix[gDpiIdx] + "P.gif";
	}
	gPopupEqnBgColor = popupBgColor;
	gPopupEqnAddPadding = (eqnOptions & 1);
	gPopupEqnAddBorder = (eqnOptions & 2);
	if (gPopupEqnAddPadding)
		gPopupEqnPadding = gPopupEqnPaddingDefault;
	else
		gPopupEqnPadding = 0;
	gNNPopupBgColor = (popupBgColor ? "#"+popupBgColor : gPopupEqnBgColorDefault); 

	// select print dpi index for GIF dimensions
	var printDpiIdx;
	if (gPrint72DPI) 
		printDpiIdx = 0; // Mac IE5.0+ must use 72dpi GIF sizes
	else if (gPrint96DPI) 
		printDpiIdx = 1; // Win IE5.5 must use 96dpi GIF sizes
	else 
		printDpiIdx = gDpiIdx; // use screen GIF sizes (default)
	
	// print attributes
	gPrintEqnWidth = eqnArray[printDpiIdx][0];
	gPrintEqnHeight = eqnArray[printDpiIdx][1];
	gPrintEqnBaseline = eqnArray[printDpiIdx][2];
	gPrintEqnLeftBearing = eqnArray[printDpiIdx][3];
	gPrintEqnRightBearing = eqnArray[printDpiIdx][4];	
	gPrintPlaceholderHeight = gPrintEqnHeight - gPrintEqnBaseline + gPlaceholderPadding;
	gPrintPlaceholderWidth = gPrintEqnWidth - gPrintEqnLeftBearing - gPrintEqnRightBearing;
	if (fileStr == "ch" || fileStr == "eq") {
		gPrintEqnSrc = gEmptySrc;
	} else {
		if (gPrint72DpiGIF) {
			gPrintEqnSrc = gSupportFolder + fileStr + "S.gif"; // Mac NN4.x needs 72dpi GIF
		} else {
			gPrintEqnSrc = gSupportFolder + fileStr + "P.gif";
		}
	}
}
}

// set equation attributes used by javascript entities (NN) or to document.write (IE)
function MPSetEqnAttrs(eqnStr, popupBGColor, eqnOptions, eqnArray) {
	MPSetAttrs(eqnStr, eqnStr, true, popupBGColor, eqnOptions, eqnArray);
}

// set symbol attributes used by javascript entities (NN) or to document.write (IE)
function MPSetChAttrs(eqnStr, fileStr, eqnArray) {
	MPSetAttrs(eqnStr, fileStr, false, null, 0, eqnArray);
}

// BEGIN NN4.x-ONLY SUPPORT CODE

// MPNNCalcTopLeft(Layer oPlaceHolder)
// This function is called from a script block before each layer.
// This appears to force Netscape to assign the necessary properties to the placeholder.
// Using function calls within the top= and left= attributes may result
// in javascript errors due to the placeholder not yet having any properties.
function MPNNCalcTopLeft(oPlaceHolder, reserveLineSpacing) {
	with (DSMP) {
		if (!gIsNN4) return;

	/* DEBUG BEGIN 
		if (typeof oPlaceHolder == "undefined") {
			if (gDebug && confirm("MPNNCalcTopLeft - oPlaceholder undefined. Reload?"))
				location.reload();
			gNNLayerTop = 0;
			gNNLayerLeft = 0;
			return;
		}
	DEBUG END */

		// must adjust to screen coordinates using gDpiRatio.
		gNNLayerTop = Math.round(oPlaceHolder.y/gDpiRatio) + (reserveLineSpacing=="1" ? gPlaceholderHeight : 1) - gScreenEqnHeight + gScreenEqnBaseline; 
		gNNLayerLeft = oPlaceHolder.x/gDpiRatio - gScreenEqnLeftBearing;
	}
}

// We initially load and position the print GIF in Netscape so that printing will work.
// After it loads, select the proper screen equation GIF
function MPNNSelectScreenEqn(oImage) {
with (DSMP) {
	if (!gIsNN4) return;

/* DEBUG BEGIN
	if (typeof oImage == "undefined" || typeof oImage.src == "undefined") {
		if (gDebug && confirm("oImage or oImage.src undefined. Reload?"))
			location.reload();
		return;
	}
DEBUG END */
		
	// if rendering on-screen in Netscape (innerWidth and innerHeight will be non-zero) ...
	if (innerWidth || innerHeight) {
		
		// no need to select another GIF when using "empty.gif"
		if (oImage.src.substr(oImage.src.length-9,9) != "empty.gif") {
		
			// ...select the appropriate screen resolution GIF
			// we can't use the global variable here because the onload may fire much later
			var source = oImage.src.substr(0,oImage.src.length-5) + gDpiSuffix[gDpiIdx] + ".gif";
			var len = source.length;
			
			// if pointing to the wrong GIF...
			if (oImage.src != source) { 
				// ... point to the correct one. This will cause this function to be called again 
				// due to the onload() handler
				oImage.src = source;
			}
				
		}
	}
}
}

// END NN4.x-ONLY SUPPORT CODE

// MPWebEQApplet - write out an APPLET tag for WebEQ
// no need to scale dimensions any more as WebEQ 3.01 adjusts for screen resolution itself
// NOTE: now we're not dynamically scaling, this function isn't really needed for WebEQ

function MPWebEQApplet(id, params, dims, fontSize72, bgColor, mathML) {
	var width = dims[0];
	var height = dims[1];
	var baseline = dims[2];
	var ascentHeight = (height - baseline);
	var fontSize = fontSize72;

	var s = '<applet code=webeq3.ViewerControl ' + 
		' id=' + id +
		' width=' + width + 
		' height=' + (2*ascentHeight) + 
		' align=middle>' +
		'<param name=size value=' + fontSize + '>' +
		'<param name=controls value=false>' +
		'<param name=align value=left>' +
		'<param name=valign value=baseline>';
	if (bgColor) {
		s += '<param name=background value="#' + bgColor + '">';
	}
	s += params +
		'<param name=eq value="' + mathML + '">' +
		'</applet>';
	
	document.write(s);
}

// MPTechexplorerObject - write out an OBJECT/EMBED tags for Techexplorer
// scale the eqn dimensions (width, height, and font size) if gScaleEquations global variable is true

function MPTechexplorerObject(id, params, dims, fontSize72, bgColor, mathML) {
	var defaultWidth = dims[0];
	var defaultHeight = dims[1];
	var baseline = dims[2];
	var fontSize = fontSize72;
	var dummyTE = eval("document.techexplorer");
	var width, height, depth, ascentHeight;
   var s = "";
   var mstyleAttrs = "";

   // we don't use literal regular expressions because the encryptor will think they are variables
   var re_amp = new RegExp("&","g");
   var re_mathOpenTag = new RegExp("<math>");
   var re_mathEndTag = new RegExp("</math>");
	
	if (gScaleEquations) {
		defaultWidth  = Math.round( ( defaultWidth  * DSMP.gDpi ) / 96 );
		defaultHeight = Math.round( ( defaultHeight * DSMP.gDpi ) / 96 );
		baseline      = Math.round( ( baseline      * DSMP.gDpi ) / 96 );
		if (DSMP.gScaleUpTEFonts) { // scale up font sizes for techexplorer on Mac
				fontSize      = Math.round( ( fontSize72    * DSMP.gDpi ) / 72 );
		} else { // scale down font sizes
				fontSize      = Math.round( ( fontSize72    * 72 ) / DSMP.gDpi );
		}
	}

	// insert <mstyle> tag with fontsize attribute and </mstyle> tag
	mstyleAttrs = "fontsize='" + fontSize + "pt'";
	if (bgColor) mstyleAttrs += " mathbackground='#" + bgColor + "'";
	mathML = mathML.replace(re_mathOpenTag,"<math><mstyle " + mstyleAttrs + ">");
	mathML = mathML.replace(re_mathEndTag,"</mstyle></math>");

	// escape the MathML for proper rendering of entities
	var escapedMathML = mathML.replace(re_amp,"&amp;");

	// write out code for Windows IE ActiveX control
	s += '<object align=absmiddle classid="clsid:5AFAB315-AD87-11D3-98BB-002035EFB1A4" codebase="AXTCHEXP.OCX"' +
	 ' id=' + id + '>' +
	 '<param name="DataType" value="1">' +
	 '<param name="AutoSize" value="TRUE">' +
	 '<param name="Data" value="' + escapedMathML + '">' +
	 params;

	var isProPluginNetscape = (navigator.plugins["IBM techexplorer Hypermedia Browser [Trial Version], Professional Edition"] != null ||
	           navigator.plugins["IBM techexplorer Hypermedia Browser, Professional Edition"] != null);

	if (navigator.appName == "Netscape" && isProPluginNetscape) {
		while ( !dummyTE.isReady() );
		width  = dummyTE.getWidthFromMMLString( mathML );
		height = dummyTE.getHeightFromMMLString( mathML );
		//getDepth call doesn't work yet
		//depth  = dummyTE.getDepthFromMMLString( mathML );
		//approximate depth using our baseline value
		depth = Math.round( (baseline * height) / defaultHeight );
	} else {
		width  = defaultWidth;
		height = defaultHeight;
		depth = baseline;
	}

	ascentHeight  = height - depth;
	s += '<embed type="application/x-techexplorer"' + 
		' pluginspage="http://www.software.ibm.com/techexplorer"' +
		' id=' + id +
		' width=' + width + 
		' height=' + (2 * ascentHeight) + 
		' align="middle"' +
		params +
		' mmldata="' + escapedMathML + '">' +
		'</embed>' +
		'</object>';
	
	document.write(s);
}
