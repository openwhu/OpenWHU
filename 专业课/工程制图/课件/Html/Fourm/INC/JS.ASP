<script language="javascript">
function openUser(id) {
	var Win = window.open("dispuser.asp?name="+id,"openScript","width=350,height=300,resizable=1,scrollbars=1,menubar=0,status=1" );
}

function openScript(url, width, height){
	var Win = window.open(url,"openScript",'width=' + width + ',height=' + height + ',resizable=1,scrollbars=yes,menubar=no,status=yes' );
}

function openDis(bid,rid,id){
	self.location="dispbbs.asp?boardid="+bid+"&RootID="+rid+"&id="+id
}

function PopWindow()
{ 
openScript('messanger.asp?action=newmsg',420,320); 
}
var nn = !!document.layers;
var ie = !!document.all;

if (nn) {
  netscape.security.PrivilegeManager.enablePrivilege("UniversalSystemClipboardAccess");
  var fr=new java.awt.Frame();
  var Zwischenablage = fr.getToolkit().getSystemClipboard();
}


var currentpos,timer; 
function initialize() 
{timer=setInterval("scrollwindow()",1);} 
function sc(){clearInterval(timer);} 
function scrollwindow() 
{currentpos=document.body.scrollTop; window.scroll(0,++currentpos); 
if (currentpos != document.body.scrollTop) sc();} 
document.onmousedown=sc 
document.ondblclick=initialize 
function New(para_URL) 
{var URL =new String(para_URL) 
window.open(URL,'','resizable,scrollbars')} 

function submitonce(theform){
//if IE 4+ or NS 6+
if (document.all||document.getElementById){
//screen thru every element in the form, and hunt down "submit" and "reset"
for (i=0;i<theform.length;i++){
var tempobj=theform.elements[i]
if(tempobj.type.toLowerCase()=="submit"||tempobj.type.toLowerCase()=="reset")
//disable em
tempobj.disabled=true
}
}
}
</script>