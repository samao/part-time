package com.idzeir.leba.vo
{
	public class GameStatusVo implements IStatus
	{
		private const PLAYING:String = "playing";
		private const READY:String = "ready";
		
		private var _status:String = READY;
		
		public function GameStatusVo()
		{
		}
		
		public function set status(value:String):void
		{
			_status = value;
		}
		
		public function get status():String
		{
			return _status
		}
		
		public function get inReady():Boolean
		{
			return _status == READY;
		}
		
		public function toReady():void
		{
			_status = READY;
		}
		
		public function get inPlaying():Boolean
		{
			return _status == PLAYING;
		}
		
		public function toPlaying():void
		{
			_status = PLAYING;
		}
	}
}