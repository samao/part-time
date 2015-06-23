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
					e.info.code == Enum.ACTION_INTO_ROOM && getAnchor(e.info.data);
				});
		}

		private function getAnchor(value:RoomInfoVo):void
		{
			G.h.post(Enum.GET_ANCHOR_BY_ROOM_ID + "?roomid=" + value.roomid, null, anchorReady, trace)
		}

		private function anchorReady(value:Object):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_GET_RTMP, data:value.data}))
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"接口调用失败[InitAnchor]"}));
			}
		}
	}
}