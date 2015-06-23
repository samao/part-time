package com.idzeir.livepush.enum
{	
	
	/**
	 * 流事件枚举
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 3, 2014 9:53:06 AM
	 *
	 **/
	
	public class RtmpEnum
	{
		static public const Connect_Success:String = "NetConnection.Connect.Success";
		
		static public const Connect_IdleTimeout:String = "NetConnection.Connect.IdleTimeout";
		static public const Connect_Closed:String = "NetConnection.Connect.Closed";
		static public const Connect_Failed:String = "NetConnection.Connect.Failed";
		static public const Connect_Rejected:String = "NetConnection.Connect.Rejected";
		static public const Connect_AppShutdown:String = "NetConnection.Connect.AppShutdown";
		static public const Connect_InvalidApp:String = "NetConnection.Connect.InvalidApp";
		
		//=========================
		static public const Stream_Success:String = "NetStream.Connect.Success";
		
		static public const Stream_Rejected:String = "NetStream.Connect.Rejected";
		static public const Stream_Failed:String = "NetStream.Connect.Failed";
		
		static public const Stream_UnpublishNotify:String = "NetStream.Play.UnpublishNotify";		
		static public const Stream_Stop:String =  "NetStream.Play.Stop";
		static public const Stream_Empty:String = "NetStream.Buffer.Empty";
		static public const Stream_Full:String = "NetStream.Buffer.Full";						
		static public const Stream_Unpause:String = "NetStream.Unpause.Notify";
		static public const Stream_Pause:String = "NetStream.Pause.Notify";
		static public const Stream_Flush:String = "NetStream.Buffer.Flush";			
		static public const Stream_Seek:String = "NetStream.Seek.Notify";
		static public const Stream_Start:String = "NetStream.Play.Start";
	}
}