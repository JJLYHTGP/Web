var EventUtil = {
	addHandler: function (element,type,handler){
		if(element.addEventListener){
			element.addEventListener(type,handler,false);
		}else if(element.attachEvent){
			element.attachEvent('on'+type,handler);
		}else{
			element['on'+type]=handler;
		}
	},
	removeHandler: function (element,type,handler){
		if(element.removeEventListener){
			element.removeEventListener(type,handler,false);
		}else if(element.detachEvent){
			element.detachEvent('on'+type,handler);
		}else{
			element['on'+type]=null;
		}
	},
	getEvent: function(event){
		return event? event:window.event;
	},
	getTarget: function(event){
		return event.target || event.srcElement;
	},
	//取消事件的默认行为
	preventDefault: function(event){
		if(event.preventDefault){
			event.preventDefault();
		}else{
			event.returnValue=false;
		}
	},
	//取消事件的进一步捕获或冒泡
	stopPropagation: function(event){
		if(event.stopPropagation){
			event.stopPropagation();
		}else{
			event.cancelBubble=true;
		}
	},
	// 获得相关元素
	getRelatedTarget: function(event){
		if(event.relatedTarget){
			return event.relatedTarget;
		}else if(event.toElement){
			return event.toElement;
		}else if(event.fromElement){
			return event.fromElement;
		}
		return null;
	},
	getButtton: function(event){
		if(document.implementation.hasFeature('MouseEvents','2.0')){
			return event.button;
		}else{
			switch(event.button){
				case 0:
				case 1:
				case 3:
				case 5:
				case 7:
					return 0;
				case 2:
				case 6:
					return 2;
				case 4:
					return 1;
			}
		}
	}
}


