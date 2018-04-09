function getElement(id){
	if(document.getElementById){
		return document.getElementById(id);
	}else if(document.all){
		return document.all[id];
	}else{
		throw new Error('No way to retrieve element!');
	}
}

//获得标签名为tagName,类名className的元素
function getElementsByClass(tagName,className) { 	
	var tagArr=[];//用于返回类名为className的元素
    if(document.getElementsByClassName){   
    	return document.getElementsByClassName(className);
    }else{    
    	var tags=document.getElementsByTagName(tagName);//获取标签
        for(var i=0;i < tags.length; i++) { 
        	var sp=tags[i].className.split(' ');
        	for(var j=0;j<sp.length;j++){
        		if(className==sp[j]) { //保存满足条件的元素
	              tagArr.push(sp[j]); 
	              break;
	            } 
        	}
   		} 
   	}
    return tagArr; 
} 