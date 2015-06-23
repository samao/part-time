package com.idzeir.livepush.module
{	
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Logger;
	import com.idzeir.core.view.VScrollBar;
	import com.idzeir.livepush.assets.TagBmd;
	import com.idzeir.livepush.enum.Enum;
	import com.idzeir.livepush.video.RtmpProxy;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.media.Video;

	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 3, 2014 11:48:12 AM
	 *
	 **/
	
	public class RtmpModule extends Module implements IVideo
	{
		protected var _rtmp:RtmpProxy;
		
		protected var video:Video;

		protected var volumeBar:VScrollBar;

		protected var tagVideo:Bitmap;
		
		public function RtmpModule(type:String)
		{
			super();
			_rtmp = new RtmpProxy(type);
			initListener();
			_e.watch(Enum.PLAY,function():void
			{
				start();
			});
		}
		
		protected function addChildren():void
		{
			
		}
		
		protected function initListener():void
		{
			_e.watch(Enum.SERVER_CHANGE,onServerChange);
			_e.watch(Enum.STREAM_CHANGE,onStreamChange);
			_e.watch(Enum.STREAM_START,start);
			_e.watch(Enum.CLEAR_LAST_FRAME,clearlastFrame);
		}
		
		protected function clearlastFrame():void
		{
			if(video)
			{
				Logger.out(this,"清除最后一帧");
				video.clear();
				video.attachNetStream(null);
				video.clear();
				video.visible = false;
				this.showVolumeBar = false;
				tagVideo.visible = false;
			}
		}
		
		private function onStreamChange(_stream:String):void
		{
			_rtmp.streamName = _stream;
		}
		
		private function onServerChange(_server:String):void
		{
			_rtmp.server = _server;
		}
		
		protected function start():void
		{
			if(video)
			{
				video.visible = true;
			}
			_rtmp.play();
		}
		
		override protected function onAdded(event:Event):void
		{
			Logger.out(this,"应用模块");
			super.onAdded(event);
			addChildren();
			
			volumeBar = new VScrollBar(null,volumeChange);
			volumeBar.setThumbPercent(.2);
			volumeBar.setSliderParams(0, 100, 0);
			volumeBar.move(stage.stageWidth - volumeBar.width - 5,(stage.stageHeight - volumeBar.height)*.5);
			
			tagVideo = new Bitmap(new TagBmd());
			tagVideo.x = stage.stageWidth - tagVideo.width - 5;
			tagVideo.y = 5;
		}
		
		protected function volumeChange(e:Event):void
		{
			if(contains(volumeBar))_rtmp.volume = 1-volumeBar.value/100;
		}
		
		protected function set showVolumeBar(bool:Boolean):void
		{
			if(bool)
			{
				this.addChild(tagVideo);
			}else{
				if(this.contains(tagVideo))
				{
					this.removeChild(tagVideo);
				}
			}
		}
		
		override protected function onRemove(event:Event):void
		{
			super.onRemove(event);
			dispose();
		}
		
		public function dispose():void
		{
			_e.remove(Enum.SERVER_CHANGE,onServerChange);
			_e.remove(Enum.STREAM_CHANGE,onStreamChange);
			_e.remove(Enum.STREAM_START,start);
			_e.remove(Enum.CLEAR_LAST_FRAME,clearlastFrame);
		}
	}
}