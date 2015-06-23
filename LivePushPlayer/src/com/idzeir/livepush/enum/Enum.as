package com.idzeir.livepush.enum
{	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 2, 2014 1:14:03 PM
	 *
	 **/
	
	public class Enum
	{
		public static var SERVER_CHANGE:String = "serverChange";
		public static var STREAM_CHANGE:String = "streamChange";
		public static var STREAM_START:String = "streamStart";
		public static var BG_CHANGE:String = "bgChange";
		public static var PLAY:String = "PLAY";
		public static var MICROPHONE:String = "microphone";
		public static var CAMERA:String = "camera";

		
		/**流可以播放事件*/
		public static var STREAM_READY:String = "streamReady";
		public static var BUFFER:String = "buffer";
		public static var FULL:String = "full";
		public static var EMPTY:String = "empty";
		public static var CONNECTION_CLOSE:String = "connectionClose";;
		public static var STOP:String = "stop";
		public static var CLEAR_LAST_FRAME:String = "clearLastFrame";
		public static var PLAY_VOLUME:String = "playVolume";
	}
}