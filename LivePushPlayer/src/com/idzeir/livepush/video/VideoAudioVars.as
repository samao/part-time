package com.idzeir.livepush.video
{
	
	import com.idzeir.core.view.Logger;
	
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.SoundCodec;

	public class VideoAudioVars
	{
		//=======Camera
		public var keyFrameInterval:int = 15;
		public var loopback:Boolean = false;
		public var width:int = 640;
		public var height:int = 480;
		public var fps:Number = 15;
		public var bandwidth:int = 44800;
		public var quality:int = 100;

		//=======H264
		public var profile:String = H264Profile.MAIN;
		public var level:String = H264Level.LEVEL_2_1;

		//=======Microphone
		public var rate:Number = 44;
		public var codec:String = SoundCodec.NELLYMOSER;
		
		//=======stream缓存出现loading时间
		public var timeout:int = 3000;
		//=======空流后清除链接的时间 ，设置0为不清楚最后一帧
		public var clearTime:int = 10000;
		//=======缓存时间毫秒
		public var bufferTime:Number = 1;
		//=======speek编码时候的降噪处理，其它编码无效
		public var noiseSuppressionLevel:Number = 0;

		static private var _instance:VideoAudioVars;

		public function VideoAudioVars()
		{
			
		}


		static public function getParams():VideoAudioVars
		{
			if (!_instance)
			{
				_instance = new VideoAudioVars();
			}
			return _instance;
		}

		public function updateFromData(value:Object):void
		{
			Logger.out(this,"=================");
			Logger.out("传入的值：\n",JSON.stringify(value));			
			Logger.out(this,"=================");
			
			if (value)
			{
				if (value.hasOwnProperty("keyFrameInterval"))
				{
					keyFrameInterval = Number(value["keyFrameInterval"]);
				}
				if (value.hasOwnProperty("loopback"))
				{
					loopback = value["loopback"]=="true"?true:false;
				}
				if (value.hasOwnProperty("width"))
				{
					width = Number(value["width"]);
				}
				if (value.hasOwnProperty("height"))
				{
					height = Number(value["height"]);
				}
				if (value.hasOwnProperty("fps"))
				{
					fps = Number(value["fps"]);
				}
				if (value.hasOwnProperty("bandwidth"))
				{
					bandwidth = Number(value["bandwidth"]);
				}
				if (value.hasOwnProperty("quality"))
				{
					quality = Number(value["quality"]);
				}

				if (value.hasOwnProperty("profile"))
				{
					profile = value["profile"];
				}
				if (value.hasOwnProperty("level"))
				{
					level = value["level"];
				}

				if (value.hasOwnProperty("rate"))
				{
					rate = Number(value["rate"]);
				}
				if (value.hasOwnProperty("codec"))
				{
					codec = value["codec"];
				}
				if (value.hasOwnProperty("timeout"))
				{
					timeout = Number(value["timeout"]);
				}
				if (value.hasOwnProperty("clearTime"))
				{
					clearTime = Number(value["clearTime"]);
				}
				if (value.hasOwnProperty("bufferTime"))
				{
					bufferTime = Number(value["bufferTime"]);
				}
				if (value.hasOwnProperty("noiseSuppressionLevel"))
				{
					noiseSuppressionLevel = Number(value["noiseSuppressionLevel"]);
				}
			}
			
			Logger.out("设置完的属性\n",JSON.stringify(this));
		}
	}
}