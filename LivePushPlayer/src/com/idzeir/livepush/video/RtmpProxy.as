package com.idzeir.livepush.video
{	
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Logger;
	import com.idzeir.livepush.enum.Enum;
	import com.idzeir.livepush.enum.RtmpEnum;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jan 14, 2011 6:24:52 PM
	 *
	 **/
	
	public class RtmpProxy extends EventDispatcher
	{
		/**
		 * 拉流代理类型
		 */
		static public const LIVE:String = "live";
		/**
		 * 推流代理类型
		 */
		static public const PUSH:String = "push";
		
		/**
		 * 当前代理类型，默认为拉流
		 */
		private var _type:String;
		
		private var _nc:NetConnection;
		private var _ns:NetStream;
		
		/**
		 * 重连次数
		 */
		private var _total:uint = 0;
		private var _server:String = "";
		private var _streamName:String = "";
		private var _volume:Number = 1;
		private var _soundTr:SoundTransform;
		
		/**
		 * 采集的硬件引用
		 */
		private var _camera:Camera;
		private var _microPhone:Microphone;
		
		public function RtmpProxy(type:String="",target:IEventDispatcher=null)
		{
			super(target);
			this._type = Utils.validateStr(type)?type:LIVE;
			
			if(!_soundTr)
			{
				_soundTr = new SoundTransform(this._volume);
			}
			
			_nc = new NetConnection();
			_nc.client = ProxyClient.instance;
			
			Utils.mediator.watch(Enum.STOP,function(value:*=null):void
			{
				clear();
				Utils.mediator.send(Enum.CLEAR_LAST_FRAME);
			});
		}
		
		public function get stream():NetStream
		{
			return _ns;
		}
		
		protected function onNetHandler(event:NetStatusEvent):void
		{
			trace(event.info.code)
			switch(event.info.code)
			{
				case RtmpEnum.Connect_Success:
					createStream();
					break;
				case RtmpEnum.Connect_AppShutdown:
				case RtmpEnum.Connect_Closed:
				case RtmpEnum.Connect_Failed:
				case RtmpEnum.Connect_IdleTimeout:
				case RtmpEnum.Connect_InvalidApp:
				case RtmpEnum.Connect_Rejected:
					Utils.mediator.send(Enum.CONNECTION_CLOSE,event.info.code);
					Utils.mediator.send(Enum.CLEAR_LAST_FRAME);
					break;
				case RtmpEnum.Stream_Empty:
					Utils.mediator.send(Enum.EMPTY);
					break;
				case RtmpEnum.Stream_UnpublishNotify:
					
					break;
				case RtmpEnum.Stream_Full:
					Utils.mediator.send(Enum.FULL);
					break;
				default:
					Logger.out(this,"未处理调用：",event.info.code);
					break;
			}
		}
		
		/**
		 * 创建流
		 */
		private function createStream():void
		{
			_ns = new NetStream(_nc);
			_ns.client = ProxyClient.instance;
			_ns.useHardwareDecoder = false;
			_ns.soundTransform = _soundTr;
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS,onNetHandler,false,0,true);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler,false,0,true);
			_ns.addEventListener(IOErrorEvent.IO_ERROR,errorHandler,false,0,true);
			var seting:H264VideoStreamSettings = new H264VideoStreamSettings();
			var _var:VideoAudioVars = VideoAudioVars.getParams();
			seting.setProfileLevel(_var.profile,_var.level);
			_ns.videoStreamSettings = seting;
			switch(_type)
			{
				case LIVE:
					_ns.bufferTime = _var.bufferTime;
					Utils.mediator.send(Enum.EMPTY);
					_ns.play(_streamName);
					break;
				case PUSH:
					_ns.useJitterBuffer = true;
					if(this._camera)
					{
						_ns.attachCamera(this._camera);
					}
					if(this._microPhone)
					{
						_ns.attachAudio(this._microPhone);
					}					
					_ns.publish(_streamName);
					break;
			}
			trace(JSON.stringify(_ns.videoStreamSettings));
			Utils.mediator.send(Enum.STREAM_READY,_ns);
		}
		
		protected function errorHandler(event:Event):void
		{
			retry();
		}
		
		/**
		 * 播放接口,什么都不传为拉流模式，推流时候传入采集的硬件设备
		 */
		public function play(_cam:Camera = null,_mic:Microphone = null):void
		{
			clear();
			if(_cam)
			{
				this._camera = _cam;
			}
			if(_mic)
			{
				this._microPhone = _mic;
			}
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
			_nc.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			_nc.addEventListener(NetStatusEvent.NET_STATUS,onNetHandler);
			try{
				_nc.connect(_server);
			}catch(e:Error){
				Logger.out(this,"连接通道失败：",e.message);
				retry();
			}
		}
		/**
		 * 重播
		 */
		private function retry():void
		{
			_total++;
			clear();
			//重新连接
			play();
		}
		
		private function clear():void
		{
			if(_ns)
			{
				_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
				_ns.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_ns.removeEventListener(NetStatusEvent.NET_STATUS,onNetHandler);
				
				_ns.close();
				_ns.dispose();			
				_ns = null;
			}
			if(_nc)
			{
				_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
				_nc.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
				_nc.removeEventListener(NetStatusEvent.NET_STATUS,onNetHandler);
				_nc.close();
			}
		}

		/**
		 * rtmp 服务器地址
		 */
		public function get server():String
		{
			return _server;
		}

		/**
		 * @private
		 */
		public function set server(value:String):void
		{
			_server = value;
		}

		/**
		 * 播放的流名称
		 */
		public function get streamName():String
		{
			return _streamName;
		}

		/**
		 * @private
		 */
		public function set streamName(value:String):void
		{
			_streamName = value;
		}

		/**
		 * 流的音量
		 */
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * @private
		 */
		public function set volume(value:Number):void
		{
			_volume = Math.max(0,value);
			_soundTr.volume = value;
			if(_ns)
			{
				_ns.soundTransform = _soundTr;
			}
		}


	}
}
import com.idzeir.core.view.Logger;

class ProxyClient extends Object {

	static private var _instance:ProxyClient;
	
	public function ProxyClient()
	{
		
	}
	static public function get instance():ProxyClient
	{
		if(!_instance)
		{
			_instance = new ProxyClient();
		}
		return _instance;
	}
	/**通道连接成功回调*/
	public function onBWDone(value:Object=null):void {
		Logger.out(this,"通道建立成功",JSON.stringify(value));
	}
	/**流连接成功回调*/
	public function onMetaData(value:Object=null):void {
		Logger.out(this,"流连接成功", JSON.stringify(value));			
	}
}