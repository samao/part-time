package com.idzeir.buissnes
{
	import com.idzeir.events.InfoEvent;
	import com.idzeir.vo.RoomInfoVo;
	
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 聊天代理
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 4, 2014||1:18:27 PM
	 */
	public class InitChatProxy
	{
		/**
		 * 每个连接聊天的唯一标记 
		 */		
		private var _session:String;
		/**
		 * 用户名 
		 */		
		private var guest:String;

		private var id:int;
		
		private var heart:int;
		
		public function InitChatProxy()
		{
			_session = String(new Date().getTime()+""+uint(Math.random()*1000)).substr(3);
			
			G.h.post(Enum.SET_GUEST_KEY+"?visitorsessionid="+_session/*+"&roomid="+value.roomid*/,null,sessionReady,trace);
			
			G.e.addEventListener(InfoEvent.SPREAD_INFO,function(e:InfoEvent):void
			{
				e.info.code == Enum.ACTION_INTO_ROOM && joinAnchorRoom(e.info.data);
			});
		}
		/**
		 * 进入艺人房间 
		 * @param value
		 * 
		 */		
		private function joinAnchorRoom(value:RoomInfoVo = null):void
		{
			clearInterval(id);
			clearInterval(heart);
			G.h.post(Enum.GUEST_JOIN_IN+"?visitorsessionid="+_session+"&roomid="+value.roomid,null,joinChat,trace);
		}
		
		/**
		 * 加入聊天反馈 
		 * @param value
		 * 
		 */		
		private function joinChat(value:* = null):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				if(guest!="")
				{
					id = setInterval(poll,6000);
					heart = setInterval(function():void
					{
						G.h.post(Enum.SEND_HEART+"?datenocache"+uint(Math.random()*1000)+"&visitorsessionid="+this._session,null,heartBack,trace);
					},10000);
				}
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"加入聊天失败[InitChatProxy]"}));
			}
		}
		/**
		 * 心跳检测反馈 
		 * @param value
		 * 
		 */		
		private function heartBack(value:* = null):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"心跳失败[InitChatProxy]"}));
			}
		}
		
		/**
		 * 发送session反馈 
		 * @param value
		 * 
		 */		
		private function sessionReady(value:* = null):void
		{
			G.h.post(Enum.GET_GUEST_INFO+"?visitorsessionid="+_session,null,guestInfoReady,trace);
		}
		/**
		 * 请求个人游客用户数据 
		 * @param value
		 * 
		 */		
		private function guestInfoReady(value:* = null):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				guest = value.data;
				trace("生成用户：",guest,_session);
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"无法生成游客[InitChatProxy]"}));
			}
		}	
		/**
		 * 请求聊天内容 
		 * 
		 */		
		private function poll():void
		{
			G.h.post(Enum.GET_CHAT_MSG+"?datenocache"+uint(Math.random()*1000)+"&username="+guest,null,chatMsg,trace);
		}
		/**
		 * 返回聊天内容 
		 * @param value
		 * 
		 */		
		private function chatMsg(value:* = null):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				if(value["data"])
				{
					var data:Object = JSON.parse(value.data);
					if(data["msg"]=="pubmsg")
					{
						data = data["data"];
						if(data["message"])
						{
							trace(data["message"]);
							G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"聊天:"+data["message"]}));
						}
					}else{
						trace("poll：",data["msg"]);
					}
				}
			}
		}		
		
	}
}