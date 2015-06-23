package com.idzeir.bussies.player
{	
	
	import com.idzeir.core.view.Slider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 7, 2014 10:27:16 AM
	 *
	 **/
	
	public class MediaPlayer extends Sprite
	{

		private var ns:NetStream;

		private var video:Video;

		private var bar:Slider;
		
		public function MediaPlayer()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			//this.mouseChildren = false;
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.client = this;
			ns.addEventListener(NetStatusEvent.NET_STATUS,statusHanndler)
			video = new Video(stage.stageWidth,stage.stageHeight);
			video.smoothing = true;
			this.addChild(video);
			
			bar = new Slider(Slider.VERTICAL);
			bar.addEventListener(Event.CHANGE,onSeek);
			bar.setSize(10,stage.stageWidth);
			bar.rotation = -90;
			bar.y=stage.stageHeight;
			this.addChild(bar);
		}
		
		protected function onSeek(event:Event):void
		{
			var leftBytes:ByteArray = new ByteArray();
			_bytes.position = 0;
			_bytes.readBytes(leftBytes,uint(bar.value*_bytes.length/bar.maximum));
			ns.seek(0);
			ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			trace(leftBytes.length,_bytes.length);
			ns.appendBytes(leftBytes);
			ns.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
		}
		
		protected function statusHanndler(event:NetStatusEvent):void
		{
			//trace(event.info.code);
			if("NetStream.Buffer.Full"==event.info.code)
			{
			}
		}
		private var _bytes:ByteArray = new ByteArray();
		public function play(bytes:ByteArray):void
		{			
			_bytes.clear();
			bytes.readBytes(_bytes);
			ns.useHardwareDecoder = false;
			ns.play(null);
			ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);	
			_bytes.position = 0;
			ns.appendBytes(_bytes);	
			video.attachNetStream(ns);
		}

		public function onMetaData(value:*=null):void
		{
			bar.maximum = value.duration;
			flash.utils.setInterval(function():void
			{
				if(!ns.inBufferSeek)bar.value = ns.time;
			},500);
		}
		
		public function onXMPData(value:*=null):void
		{
			
		}
	}
}