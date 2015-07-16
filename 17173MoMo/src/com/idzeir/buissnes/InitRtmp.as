package com.idzeir.buissnes
{
	import com.idzeir.events.InfoEvent;

	/**
	 * 读取rtmp地址业务
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class InitRtmp
	{
		public function InitRtmp()
		{
			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(e:InfoEvent):void
				{
					e.info.code == Enum.ACTION_GET_RTMP && getRtmp(e.info.data);
				});
		}

		private function getRtmp(value:*):void
		{
			trace(value);
			G.h.post(Enum.GET_STREAM_ADDRESS + "?username=" + value, null, rtmpReady, trace)
		}

		private function rtmpReady(value:*):void
		{
			if (value["msg"] == "OK" && value["errcode"] == "0")
			{
				trace("rtmp:", JSON.stringify(value));
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_PlAY_STREAM, data:value.data}));
			}else{
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"接口调用失败[InitRtmp]"}));
			}
		}
	}
}