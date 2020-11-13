var picwin=null;
 picwinX = screen.availWidth/2
 picwinY =screen.availHeight/2
function openpicwin(picurl)
{if(picwin==null)
 {picwin=window.open(picurl,'picwin1','scrollbars=no,resizable=no,width=1,height=1,top='+ picwinY + ',left=' + picwinX)
  picwin.focus(); 
  openpingwin()} 
 else
 {if(picwin.closed==true)
  {picwin=window.open(picurl,'picwin','scrollbars=no,resizable=no,width=1,height=1,top='+ picwinY + ',left=' + picwinX)
   picwin.focus(); 
   openpingwin()} 
  else 
  {picwin.focus(); picwin.location=picurl;openpingwin()}}
}
function openpingwin()
{for(i=1;i<=10;++i)
   {picwin.resizeTo(36*i,16*i)
    picwin.moveTo(picwinX-18*i,picwinY-8*i)
    }
}