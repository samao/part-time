package com.idzeir.buissnes
{
	import com.idzeir.events.InfoEvent;
	import com.idzeir.vo.RoomInfoVo;

	/**
	 * 读取艺人信息
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class InitAnchor
	{
		
		public function InitAnchor()
		{
			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(e:InfoEvent):void
				{
					e.info.code == Enum.ACTION_INTO_ROOM && getRequestKey(e.info.data);
				});
		}

		private function getRequestKey(value:RoomInfoVo):void
		{
			switch(value.type)
			{
				case InitLobby.TYPE_17173:
					G.h.post(Enum.GET_ANCHOR_BY_ROOM_ID + "?roomId=" + value.roomid, null, anchorReady17173, trace)
					break;
				case InitLobby.TYPE_WOHAI:
					G.h.post(Enum.GET_WOHAI_ANCHOR_BY_ROOM_ID + "?roomid=" + value.roomid, null, anchorReadyWohai, trace)
					break;
			}
		}
		
		private function anchorReadyWohai(value:Object):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_GET_RTMP, data:value.data}))
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"接口调用失败[InitAnchor]"}));
			}
		}

		private function anchorReady17173(value:Object):void
		{
			if (value["code"] == "000000")
			{
				getRtmpInfo(value.obj.liveInfo);
				//G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_GET_RTMP, data:value.data}))
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"接口调用失败[InitAnchor]"}));
			}
		}
		
		private function getRtmpInfo(value:Object):void
		{
			//http://gslb.v.17173.com/show/live?
			//optimal=1&name=1343462%5F1437025238970&prot=3&ver=2&cdntype=9&btype=1&
			//ckey=F1ZIFpvf3LwBzCR&sip=&t=0%2E8946300600655377&cid=1192561718
			var masterId:Number = value.masterId;
			var optimal:Number = 0;
			var liveId:Number = value.liveId;
			var stareamName:String = value.streamName;
			var cdnType:Number = value.cdnType;
			var port:Number = 3;
			var ver:Number = 3;
			var btype:Number = 1;
			var ckey:String = value.ckey;
			var cid:Number = value.cid;
			var url:String = Enum.GSLB_URL+"?optimal="+optimal+"" +
				"&name="+stareamName+"" +
				"&prot=3&ver=2&cdntype="+cdnType+"" +
				"&btype=1&ckey="+ckey+"&sip=" +
				"&t="+Math.random()+"&cid="+cid;
				
			G.h.post(url,null,getRtmpAddress,trace);
		}
		
		private function getRtmpAddress(value:Object):void
		{
			
			var ip:String = value.ip;
			var port:String = value.port;
			var key:String = value.key;
			var object:Object = {};
			
			if(port == ""){
				if(ip.indexOf("rtmp://") != -1){
					object.connectionURL = ip;
					object.streamName = key;
				}else{
					object.connectionURL = null;
					object.streamName = ip + port +key;
				}
			}else{
				var portPart:String = "";
				var array:Array = port.split("|");
				if(array.length > 0){
					portPart = array[0];
				}
				object.connectionURL = null;
				object.streamName = ip + portPart +key;
			}
			//trace("getRtmpAddress:",JSON.stringify(value));
			if (value["code"] == "000000")
			{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_PlAY_STREAM, data:object}));
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"接口调用失败[InitAnchor]"}));
			}
		}
	}
}