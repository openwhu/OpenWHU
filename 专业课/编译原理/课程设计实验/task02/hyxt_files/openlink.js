function _openSelectLink(selecto, linkname, addclicktimename)
{
    if(linkname == undefined || linkname == "")
        linkname = "value";
        
        
    var index = selecto.selectedIndex;
    var option = selecto.options[index];
    
    var url = option.getAttribute("value");
    if(addclicktimename != undefined && addclicktimename != "")
    {
        try
        {
            eval(option.getAttribute(addclicktimename))
        }
        catch(e)
        {
        }
    }
    
    window.open(url);
    
    if(selecto.selectedIndex != 0)    
    {    
        selecto.selectedIndex = 0;    
    }   
}