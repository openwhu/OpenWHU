var _jsq_image = new Image();
function _jsq_encode(){_keyStr="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";this.encode=function(a){if(a==null||a==undefined||a=="")return"";var b=new Array();var c,chr2,chr3;var d,enc2,enc3,enc4;var i=0;a=_utf8_encode(a);while(i<a.length){c=a[i++];chr2=a[i++];chr3=a[i++];d=c>>2;enc2=((c&3)<<4)|(chr2>>4);enc3=((chr2&15)<<2)|(chr3>>6);enc4=chr3&63;if(isNaN(chr2)){enc3=enc4=64}else if(isNaN(chr3)){enc4=64}b.push(_keyStr.charAt(d)+_keyStr.charAt(enc2)+_keyStr.charAt(enc3)+_keyStr.charAt(enc4))}return escape(b.join(''))};_utf8_encode=function(a){a=a.replace(/\r\n/g,"\n");var b=new Array();var d=0;for(var n=0;n<a.length;n++){var c=a.charCodeAt(n);if(c<128){b[d++]=c}else if((c>127)&&(c<2048)){b[d++]=(c>>6)|192;b[d++]=(c&63)|128}else{b[d++]=(c>>12)|224;b[d++]=((c>>6)&63)|128;b[d++]=(c&63)|128}}return b}}
function _jsq_(treeid, pagename, newsid, owner)
{
    if(window.top != window)
        return;
    
    var c = navigator.appName=='Netscape'?screen.pixelDepth:screen.colorDepth;
    var e = new _jsq_encode();
    var r = '&e=1&w='+screen.width + '&h='+ screen.height+'&treeid='+treeid+'&refer='+e.encode(document.referrer)+ '&pagename='+e.encode(pagename)+'&newsid='+newsid;
    _jsq_image.src = "/system/resource/code/datainput.jsp?owner="+owner+ r;
}