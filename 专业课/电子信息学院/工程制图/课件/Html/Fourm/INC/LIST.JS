function viewPage2(ipage){
        document.frmList2.Page.value=ipage
        document.frmList2.submit()        
     }
     function viewPage1(ipage){
        document.frmList2.Page.value=ipage
        document.frmList2.submit()        
}

function loadThreadFollow(t_id,a_id,b_id){
	var targetImg =eval("followImg" + t_id);
	var targetDiv =eval("follow" + t_id);
	if (targetImg.src.indexOf("nofollow")!=-1){return false;}
	if ("object"==typeof(targetImg)){
		if (targetDiv.style.display!='block'){
			targetDiv.style.display="block";
			targetImg.src="pic/minus.gif";
			if (targetImg.loaded=="no"){
				document.frames["hiddenframe"].location.replace("loadtree1.asp?boardid="+b_id+"&rootid="+t_id+"&id=" + a_id);
			}
		}else{
			targetDiv.style.display="none";
			targetImg.src="pic/plus.gif";
		}
	}
}

function resumeTree(rootid){
	loadThreadFollow(rootid);
}