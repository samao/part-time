package com.idzeir.livepush.module
{	
	import com.idzeir.core.Context;
	import com.idzeir.core.interfaces.ITicker;
	import com.idzeir.core.view.Logger;
	import com.idzeir.livepush.assets.BufferIcon;
	import com.idzeir.livepush.enum.Enum;
	import com.idzeir.livepush.video.RtmpProxy;
	import com.idzeir.livepush.video.VideoAudioVars;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Video;
	import flash.net.NetStream;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jan 14, 2011 6:23:36 PM
	 *
	 **/
	
	public class LiveModule extends RtmpModule implements IVideo
	{

		private var buffering:MovieClip;

		private var iticker:ITicker;
		
		public function LiveModule()
		{
			super(RtmpProxy.LIVE);
			_e.watch(Enum.PLAY_VOLUME,function(value:Number):void
			{
				_rtmp.volume = value;
			});
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			iticker = (Context.getContext("ticker") as ITicker);
			video = new Video(stage.stageWidth,stage.stageHeight);
			video.smoothing = true;
			video.deblocking = 2;
			this.addChild(video);
			
			//流建立成功可以播放了
			_e.watch(Enum.STREAM_READY,onReady);
			//缓存中
			_e.watch(Enum.BUFFER,onBuffer);
			//缓存已满
			_e.watch(Enum.FULL,onFull);
			//缓存空了
			_e.watch(Enum.EMPTY,onEmpty);
			
			buffering = new BufferIcon();
			buffering.x = video.width>>1;
			buffering.y = video.height>>1;
			isBuffering = false;
			this.addChild(buffering);
		}
		
		private function onReady(_ns:NetStream):void
		{
			this.showVolumeBar = true;
			Logger.out(this,"开始播放,视频可见：",video.visible);
			video.clear();
			video.visible = true;
			video.attachNetStream(_ns);
			this.tagVideo.visible = true;
		}
		
		override protected function clearlastFrame():void
		{
			super.clearlastFrame();
			isBuffering = false;
		}
		
		public function set isBuffering(bool:Boolean):void
		{
			if(!bool)
			{
				iticker.remove(playBuffering);
				buffering.visible = false;
				buffering.stop();
				iticker.remove(closeStream);
			}else{
				iticker.call(VideoAudioVars.getParams().timeout,playBuffering,1)
			}
		}
		
		override protected function set showVolumeBar(bool:Boolean):void
		{
			super.showVolumeBar = bool;
			if(bool)
			{
				//this.addChild(this.volumeBar);
			}else{
				if(this.contains(this.volumeBar))
				{
					this.removeChild(this.volumeBar);
				}
			}
		}
		
		private function playBuffering(value:*):void
		{
			buffering.visible = true;
			buffering.play();
			var clearTimer:int = VideoAudioVars.getParams().clearTime
			if(clearTimer>0&&!iticker.has(closeStream))
			{
				iticker.call(clearTimer,closeStream,1);
			}
		}
		
		private function closeStream(value:*=null):void
		{
			_e.send(Enum.CONNECTION_CLOSE,"10s没收到流");
			//iticker.remove(closeStream);
			//_e.send(Enum.STOP);
			clearlastFrame();
		}
		
		private function onBuffer():void
		{
			
		}
		
		private function onFull():void
		{
			isBuffering = false;
		}
		
		private function onEmpty():void
		{
			isBuffering = true;
		}
		
		override public function dispose():void
		{
			super.dispose()
		}
	}
}