function openchromeless(theURL, wname, W, H, CLOSEdwn, CLOSEup, CLOSEovr, NONEgrf, CLOCKgrf, winTIT, winREALtit , winBORDERCOLOR, winBORDERCOLORsel, winBGCOLOR) {

	var windowW = W;
	var windowH = H;
	var windowX = Math.ceil( (window.screen.width  - windowW) / 2 );
	var windowY = Math.ceil( (window.screen.height - windowH) / 2 );

	if (navigator.appName == "Microsoft Internet Explorer" && parseInt(navigator.appVersion)>=4) isie=true
	else											     isie=false

	if (isie) { H=H+22+10+2; W=W+10+10+2; }

	s = ",width="+W+",height="+H;

	if (isie && (navigator.userAgent.toLowerCase().indexOf("win")!=-1) ) {

var dowin = theURL != "" ? true : false;

var chromeTIThtml = '\n' +
'<html>																							'+ '\n'+
'<head>                                                                                                                                                                         	'+ '\n'+
'<title>&nbsp;CHROMELESS WINDOWS / TITLEBAR</title>                                                                                                                      		'+ '\n'+
'<style type="text/css">                                                                                                                                                  	    	'+ '\n'+
'#mywinTITLE 	{ position: absolute; left:   0px; top:   0px; width: 100%; height: 22px; z-index: 1; background-color: '+winBGCOLOR+'; clip:rect(0,100%,22,0); }         		'+ '\n'+
'#mywindow 	{ position: absolute; left:   0px; top:   0px; width: 100%; height: 22px; z-index: 2;                           	clip:rect(0,100%;22,0); }	 		'+ '\n'+
'#mywindowCLOSE { position: absolute; left: -22px; top: -22px; width: 11px; height: 11px; z-index: 3;                           	clip:rect(0,11,11,0);   }         		'+ '\n'+
'#myCLOCKgrf 	{ position: absolute; left: -22px; top: -22px; width: 11px; height: 11px; z-index: 3;                            	clip:rect(0,11,11,0);   }         		'+ '\n'+
'</style>                                                                                                                                                                       	'+ '\n'+
'<script language="javascript">																				'+ '\n'

if ( theURL != "" ) {

chromeTIThtml = chromeTIThtml + 
'	theURL 	    	    = "'+theURL			+'"                                                                                                                             '+ '\n'+
'	CLOSEdwn 	    = "'+CLOSEdwn		+'"                                                                                                                             '+ '\n'+
'	CLOSEup 	    = "'+CLOSEup		+'"                                                                                                                             '+ '\n'+
'	CLOSEovr 	    = "'+CLOSEovr		+'"                                                                                                                             '+ '\n'+
'	CLOCKgrf            = "'+CLOCKgrf            	+'"                                                                                                                             '+ '\n'+
'	winBORDERCOLOR      = "'+winBORDERCOLOR		+'"                                                                                                                             '+ '\n'+
'	winBORDERCOLORsel   = "'+winBORDERCOLORsel	+'"                                                                                                                             '+ '\n'+
'	winBGCOLOR          = "'+winBGCOLOR	        +'"                                                                                                                             '+ '\n'

} else {

chromeTIThtml = chromeTIThtml + 
'	theURL="about:blank"                                                                                                                                                            '+ '\n'+
'	CLOSEdwn 		= "img/close_a.gif"                                                                                                                                     '+ '\n'+
'	CLOSEup 		= "img/close_d.gif"                                                                                                                                     '+ '\n'+
'	CLOSEovr 		= "img/close_o.gif"                                                                                                                                     '+ '\n'+
'	CLOCKgrf         	= "img/clock.gif"                                                                                                                             		'+ '\n'+
'	winTIT 	    		= "<font face=verdana size=1>&nbsp;?window title</font>"                                                                                               '+ '\n'+
'	winBORDERCOLOR   	= "#000000"                                                                                                                                             '+ '\n'+
'	winBORDERCOLORsel	= "#FF8A00"                                                                                                                                             '+ '\n'+
'	winBGCOLOR    		= "#d7dcd9"                                                                                                                                             '+ '\n'

}

chromeTIThtml = chromeTIThtml + 
'var windowCLOSEIMGdwn = new Image(); windowCLOSEIMGdwn.src = CLOSEdwn;                                                                                                            '+ '\n'+
'var windowCERRARImg_d = new Image(); windowCERRARImg_d.src = CLOSEup;                                                                                                            '+ '\n'+
'var windowCERRARImg_o = new Image(); windowCERRARImg_o.src = CLOSEovr;                                                                                                            '+ '\n'+
'var CLOCKgrfImg    = new Image();    CLOCKgrfImg.src = CLOCKgrf;                                                                                                              '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'function mouseSTATUS() {                                                                                                                                                               '+ '\n'+
'	this.x       = null;                                                                                                                                                            '+ '\n'+
'	this.y       = null;                                                                                                                                                            '+ '\n'+
'	this.bt      = "up";                                                                                                                                                            '+ '\n'+
'	this.oldx    = null;                                                                                                                                                            '+ '\n'+
'	this.oldy    = null;                                                                                                                                                            '+ '\n'+
'	this.dx      = null;                                                                                                                                                            '+ '\n'+
'	this.dy      = null;                                                                                                                                                            '+ '\n'+
'	this.screeny = null;                                                                                                                                                            '+ '\n'+
'	this.screenx = null;                                                                                                                                                            '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'	this.element = null;                                                                                                                                                            '+ '\n'+
'	this.event   = null;                                                                                                                                                            '+ '\n'+
'}                                                                                                                                                                                      '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'var mouse = new mouseSTATUS();                                                                                                                                                         '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'function actualizateMouseSTATUS(e) {                                                                                                                                                   '+ '\n'+
'	if (!e) var e = event                                                                                                                                                           '+ '\n'+
'	if ( (e.type=="mousedown" || e.type=="mouseup") && e.button!=1) return true                                                                                                     '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'	var x=e.x+document.body.scrollLeft                                                                                                                                              '+ '\n'+
'	var y=e.y+document.body.scrollTop                                                                                                                                               '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'	mouse.x   = x;                                                                                                                                                                  '+ '\n'+
'	mouse.y   = y;                                                                                                                                                                  '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'	     if ( e.type == "mousedown" ) mouse.bt = "down";                                                                                                                            '+ '\n'+
'	else if ( e.type == "mouseup" )   mouse.bt = "up";                                                                                                                              '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'	if (window.event) {                                                                                                                                                             '+ '\n'+
'		mouse.screenx=window.event.screenX;                                                                                                                                     '+ '\n'+
'		mouse.screeny=window.event.screenY;                                                                                                                                     '+ '\n'+
'	} else {                                                                                                                                                                        '+ '\n'+
'		mouse.screenx=-1;                                                                                                                                                       '+ '\n'+
'		mouse.screeny=-1;                                                                                                                                                       '+ '\n'+
'	}                                                                                                                                                                               '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'}                                                                                                                                                                                      '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'function initMouseEvents() {                                                                                                                                                           '+ '\n'+
'	document.onmousedown   = actualizateMouseSTATUS                                                                                                                                 '+ '\n'+
'	document.onmousemove   = actualizateMouseSTATUS                                                                                                                                 '+ '\n'+
'	document.onmouseup     = actualizateMouseSTATUS                                                                                                                                 '+ '\n'+
'	document.onselectstart = selectstart                                                                                                                                            '+ '\n'+
'	document.ondragstart   = new Function("actualizateMouseSTATUS(event); return false;")                                                                                           '+ '\n'+
'       document.oncontextmenu = new Function("return false;")																'+ '\n'+
'}                                                                                                                                                                                      '+ '\n'+
'                                                                                                                                                                                       '+ '\n'+
'function selectstart(){                                                                                                                                                                '+ '\n'+
'	if ( event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") { return false; }                                                                           '+ '\n'+
'	else { mouse.bt="up"; return true; }                                                                                                                                            '+ '\n'+
'}                                                                                                                                                                                      '+ '\n'+
'																							'+ '\n'+
'initMouseEvents()                                                                                                                                                                      '+ '\n'+
'																							'+ '\n'+
'var mywindowbt    ="up";                                                                                                                                                               '+ '\n'+
'var wincloseSTATUS="up";                                                                                                                                                               '+ '\n'+
'																							'+ '\n'+
'var ofx=0;                                                                                                                                                                             '+ '\n'+
'var ofy=0;                                                                                                                                                                             '+ '\n'+
'var opx=0;                                                                                                                                                                             '+ '\n'+
'var opy=0;                                                                                                                                                                             '+ '\n'+
'var px=0;                                                                                                                                                                              '+ '\n'+
'var py=0;                                                                                                                                                                              '+ '\n'+
'																							'+ '\n'+
'var wcpx1=-1, wcpy1=-1;                                                                                                                                                                '+ '\n'+
'var wcpx2=-1, wcpy2=-1;                                                                                                                                                                '+ '\n'+
'																							'+ '\n'+
'var wclosechanged = false;                                                                                                                                                             '+ '\n'+
'																							'+ '\n'+
'function initToMoveWin() {                                                                                                                                                             '+ '\n'+
'		if (wincloseSTATUS=="up" && ( mywindowbt=="up" || mywindowbt=="over") ) {                                                                                               '+ '\n'+
'					                                                 												'+ '\n'+
'				if ( parent.mainloaded ) document.all["myCLOCKgrf"].style.visibility = "hidden";                                                 			'+ '\n'+
'					                                                 												'+ '\n'+
'				document.all["myCLOCKgrf"].style.pixelLeft=document.body.clientWidth-36 										'+ '\n'+
'				document.all["myCLOCKgrf"].style.pixelTop =5                                                                         				        '+ '\n'+
'					                                                 												'+ '\n'+
'				wcpx1 = document.all["mywindowCLOSE"].style.pixelLeft=document.body.clientWidth-21                                                                      '+ '\n'+
'				wcpy1 = document.all["mywindowCLOSE"].style.pixelTop = 5                                                                                                '+ '\n'+
'				wcpx2 = wcpx1 + 11 - 1                                                                                                                                  '+ '\n'+
'				wcpy2 = wcpy1 + 11 - 1                                                                                                                                  '+ '\n'+
'				if ( mouse.x >= wcpx1 && mouse.x <= wcpx2 && mouse.y >= wcpy1 && mouse.y <= wcpy2) {                                                                    '+ '\n'+
'					if (wclosechanged == false) {                                                                                                                   '+ '\n'+
'						document.all["mywindowCLOSE"].document.images["closewin"].src=windowCERRARImg_o.src                                                     '+ '\n'+
'						wclosechanged = true                                                                                                                    '+ '\n'+
'					}                                                                                                                                               '+ '\n'+
'						                                                                                                                                        '+ '\n'+
'				} else if (wclosechanged == true) {                                                                                                                     '+ '\n'+
'					document.all["mywindowCLOSE"].document.images["closewin"].src=windowCERRARImg_d.src                                                             '+ '\n'+
'					wclosechanged = false                                                                                                                           '+ '\n'+
'				}                                                                                                                                                       '+ '\n'+
'		}                                                                                                                                                                       '+ '\n'+
'																							'+ '\n'+
'		     if (   mouse.y <= 22 && mouse.y >= 1   && mywindowbt == "up"   && mouse.bt =="up"    ) { mywindowbt = "over" }                                                     '+ '\n'+
'		else if ( ( mouse.y  > 22 || mouse.y <  1 ) && mywindowbt == "over" && mouse.bt =="up"    ) { mywindowbt = "up"   }                                                     '+ '\n'+
'		else if (   mouse.y <= 22 && mouse.y >= 1   && mywindowbt == "over" && mouse.bt == "down" ) {                                                                           '+ '\n'+
'			self.window.focus();                                                                                                                                            '+ '\n'+
'	                                                                                                                                                                                '+ '\n'+
'			if ( mouse.x >= wcpx1 && mouse.x <= wcpx2 && mouse.y >= wcpy1 && mouse.y <= wcpy2 ) {                                                                           '+ '\n'+
'				wincloseSTATUS="down"                                                                                                                                   '+ '\n'+
'				document.all["mywindowCLOSE"].document.images["closewin"].src=windowCLOSEIMGdwn.src                                                                     '+ '\n'+
'			} else {                                                                                                                                                        '+ '\n'+
'				parent.bordeT.document.bgColor = winBORDERCOLORsel                                                                                                   '+ '\n'+
'				parent.bordeB.document.bgColor = winBORDERCOLORsel                                                                                                	'+ '\n'+
'				parent.bordeL.document.bgColor = winBORDERCOLORsel                                                                                                	'+ '\n'+
'				parent.bordeR.document.bgColor = winBORDERCOLORsel                                                                                                	'+ '\n'+
'				ofx =  mouse.x;                                                                                                                                         '+ '\n'+
'				ofy =  mouse.y;                                                                                                                                         '+ '\n'+
'				opx =  mouse.x;                                                                                                                                         '+ '\n'+
'				opy =  mouse.y;                                                                                                                                         '+ '\n'+
'			}	                                                                                                                                                        '+ '\n'+
'			mywindowbt="down";                                                                                                                                              '+ '\n'+
'		}                                                                                                                                                                       '+ '\n'+
'		else if ( mouse.bt =="up" && mywindowbt == "down" ) {                                                                                                                   '+ '\n'+
'			mywindowbt="up";                                                                                                                                                '+ '\n'+
'			ofx=0;                                                                                                                                                          '+ '\n'+
'			ofy=0;                                                                                                                                                          '+ '\n'+
'			opx=0;                                                                                                                                                          '+ '\n'+
'			opy=0;                                                                                                                                                          '+ '\n'+
'																							'+ '\n'+
'			if ( mouse.x >= wcpx1 && mouse.x <= wcpx2 && mouse.y >= wcpy1 && mouse.y <= wcpy2 && wincloseSTATUS=="down" ) { top.window.close() }                            '+ '\n'+
'																							'+ '\n'+
'			wincloseSTATUS="up"                                                                                                                                             '+ '\n'+
'		                                                                                                                                                                        '+ '\n'+
'			if ( document.all["mywinTITLE"] ) {                                                                                                                          	'+ '\n'+
'				parent.bordeT.document.bgColor = winBORDERCOLOR                                                                                                    	'+ '\n'+
'				parent.bordeB.document.bgColor = winBORDERCOLOR                                                                                                    	'+ '\n'+
'				parent.bordeL.document.bgColor = winBORDERCOLOR                                                                                                  	'+ '\n'+
'				parent.bordeR.document.bgColor = winBORDERCOLOR                                                                                                    	'+ '\n'+
'			}                                                                                                                                                               '+ '\n'+
'																							'+ '\n'+
'		}                                                                                                                                                                       '+ '\n'+
'		else if ( mywindowbt == "down" && wincloseSTATUS == "up") {                                                                                                             '+ '\n'+
'			var m_scrx = mouse.screenx;                                                                                                                                     '+ '\n'+
'			var m_scry = mouse.screeny;                                                                                                                                     '+ '\n'+
'			opx = px + ofx - m_scrx;                                                                                                                                        '+ '\n'+
'			opy = py + ofy - m_scry;                                                                                                                                        '+ '\n'+
'			px = m_scrx - ofx;                                                                                                                                              '+ '\n'+
'			py = m_scry - ofy;                                                                                                                                              '+ '\n'+
'			top.window.moveTo(px , py);                                                                                                                                     '+ '\n'+
'		}                                                                                                                                                                       '+ '\n'+
'	setTimeout("initToMoveWin()",20);                                                                                                                                               '+ '\n'+
'}                                                                                                                                                                                      '+ '\n'+
'</script>                                                                                												'+ '\n'+
'</head>                                                                                                                                                                        	'+ '\n'+
'<body TOPMARGIN=0 LEFTMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 scroll=no style="border: 0px solid '+ winBORDERCOLOR +'; overflow: hidden; margin: 0pt;" bgcolor='+winBGCOLOR+'>  		'+ '\n'+
'<div id=mywindow><img src="'+NONEgrf+'" width=100% height=22></div>                                                                                                             	'+ '\n'+
'<div id=mywinTITLE>'+ '<table width=100% height=22 border=0 cellpadding=0 cellspacing=0><tr><td valign=middle align=left>'+winTIT+'</td></tr></table>' +'</div>                  	'+ '\n'+
'<div id=mywindowCLOSE><a href=javascript:window.close()><img name=closewin src="'+ CLOSEup +'" border=0 width=11 height=11></a></div>                                                                                  	'+ '\n'+
'<div id=myCLOCKgrf><a href=javascript:window.close()><img name=clockwin src="'+ CLOCKgrf   +'" border=0 width=11 height=11></a></div>                                                                                  	'+ '\n'+
'</body>                                                                                                                                                                        	'+ '\n'+
'<script>initToMoveWin();</script>																			'+ '\n'+
'</html>                                                                                                                                                                        	'+ '\n'

var chromeFRMhtml = '' +
'<HTML>																									'+ '\n'+
'<HEAD>                                                                         															'+ '\n'+
'<TITLE>'+ winREALtit +'</TITLE>                                          																'+ '\n'+
'</HEAD>                                                                        															'+ '\n'+
'<script> 																								'+ '\n'+
'mainloaded = false																							'+ '\n'+
'function generatetitle() { 																						'+ '\n'+
'	if( window.frames["frmTIT"] && window.frames["bordeL"] && window.frames["bordeB"] && window.frames["bordeR"] && window.frames["noneL"] && window.frames["noneR"] && window.frames["noneB"] ) {	'+ '\n'+
'		frmTIT.document.open();																					'+ '\n'+
'		frmTIT.document.write( "'+ quitasaltolinea(chromeTIThtml) +'" );															'+ '\n'+
'		frmTIT.document.close();																				'+ '\n'+
'		 noneL.document.bgColor="'+ winBGCOLOR +'"																		'+ '\n'+
'		 noneR.document.bgColor="'+ winBGCOLOR +'"																		'+ '\n'+
'		 noneB.document.bgColor="'+ winBGCOLOR +'"																		'+ '\n'+
'		bordeL.document.bgColor="'+ winBORDERCOLOR +'"																		'+ '\n'+
'		bordeR.document.bgColor="'+ winBORDERCOLOR +'"																		'+ '\n'+
'		bordeB.document.bgColor="'+ winBORDERCOLOR +'"																		'+ '\n'+
'		bordeT.document.bgColor="'+ winBORDERCOLOR +'"																		'+ '\n'+
'	} else {																							'+ '\n'+
'		setTimeout("generatetitle()",200)																			'+ '\n'+
'	}																								'+ '\n'+
'}																									'+ '\n'+
'generatetitle()																							'+ '\n'+
'</script>																								'+ '\n'+
'<frameset border=0 framespacing=0 frameborder=0 rows="22,100%,10" onload="mainloaded=true" onreadystatechange="generatetitle()">									'+ '\n'+
'	<frame name=frmTIT src="about:blank" scrolling=no noresize>  																	'+ '\n'+
'	<frameset border=0 framespacing=0 frameborder=0 cols="10,1,100%,1,10">        															'+ '\n'+
'		<frame name=noneL src="about:blank" scrolling=no noresize> 																'+ '\n'+
'		<frame name=bordeL src="about:blank" scrolling=no noresize> 																'+ '\n'+
'			<frameset border=0 framespacing=0 frameborder=0 rows="1,100%,1">        													'+ '\n'+
'				<frame name=bordeT src="about:blank" scrolling=no noresize> 														'+ '\n'+
'				<frame name=main   src="'+theURL+'">                   															'+ '\n'+
'				<frame name=bordeB src="about:blank" scrolling=no noresize> 														'+ '\n'+
'			</frameset>                                                             													'+ '\n'+
'		<frame name=bordeR src="about:blank" scrolling=no noresize> 																'+ '\n'+
'		<frame name=noneR src="about:blank" scrolling=no noresize> 																'+ '\n'+
'	</frameset>                                                             															'+ '\n'+
'	<frame name=noneB src="about:blank" scrolling=no noresize>         																'+ '\n'+
'</frameset>                                                                    															'+ '\n'+
'</HTML>                                                                        															'

		splashWin = window.open( "" , wname, "fullscreen=1,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0"+s);

		splashWin.resizeTo( Math.ceil( W )       , Math.ceil( H ) );
		splashWin.moveTo  ( Math.ceil( windowX ) , Math.ceil( windowY ) );

		splashWin.document.open();
		splashWin.document.write( chromeFRMhtml );
		splashWin.document.close();

	}
	else    {
		var splashWin = window.open(theURL, wname, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1"+s, true);
	}

	splashWin.focus();
}                                                                               
                                                                                
function quitasaltolinea(txt) {

  var salida = txt.toString()
  var re     = /\\/g; var salida = salida.replace(re, "\\\\");
  var re     = /\//g; var salida = salida.replace(re, "\\\/");
  var re     = /\"/g; var salida = salida.replace(re, "\\\"");
  var re     = /\'/g; var salida = salida.replace(re, "\\\'");
  var re     = /\n/g; var salida = salida.replace(re, "\\n");
  var re     = /  /g; var salida = salida.replace(re, "");
  var re     = /\t/g; var salida = salida.replace(re, "");
  var re     = /\r/g; var salida = salida.replace(re, "");

  return salida

}
