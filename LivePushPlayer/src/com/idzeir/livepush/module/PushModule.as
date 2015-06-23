package com.idzeir.livepush.module
{	
	import com.idzeir.core.Context;
	import com.idzeir.core.interfaces.ITicker;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.DropDownList;
	import com.idzeir.core.view.HGroup;
	import com.idzeir.core.view.Label;
	import com.idzeir.core.view.Logger;
	import com.idzeir.livepush.enum.Enum;
	import com.idzeir.livepush.video.RtmpProxy;
	import com.idzeir.livepush.video.VideoAudioVars;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jan 14, 2011 6:23:00 PM
	 *
	 **/
	
	public class PushModule extends RtmpModule implements IVideo
	{
		private var cams:Array;

		private var mics:Array;
		/**
		 * 音频
		 */
		private var micDp:DropDownList;
		/**
		 * 摄像头
		 */
		private var camDp:DropDownList;
		
		/**选择组件*/
		private var hBox:HGroup;

		private var cam:Camera;

		private var mic:Microphone;

		private var statsText:Text;
		
		//js设置麦和摄像头名称
		private var jsData:Object = {};
		
		public function PushModule()
		{
			super(RtmpProxy.PUSH);
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			_e.watch(Enum.CAMERA,setCamera);
			_e.watch(Enum.MICROPHONE,setMicrophone);
		}
		
		private function setMicrophone(mic:String):void
		{
			jsData.mic = mic;
		}
		
		private function setCamera(cam:String):void
		{
			jsData.cam = cam;
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			video = new Video(stage.stageWidth,stage.stageHeight);
			video.smoothing = true;
			video.deblocking = 2;
			this.addChild(video);
			
			if(Camera.isSupported)
			{
				cams = Camera.names;
			}
			Logger.out(this,"摄像头",cams.join(","));

			if(Microphone.isSupported)
			{
				mics = Microphone.names;
			}
			Logger.out(this,"音频",mics.join(","));
			
			setUpHardware();
			
			statsText = new Text();
			this.addChild(statsText);
			statsText.visible = false;
		}
		
		private function streamReady(value:*):void
		{
			video.visible = true;
			this.showVolumeBar = true;
			statsText.visible = true;
			(Context.getContext("ticker") as ITicker).call(200,statusFlush);
			this.tagVideo.visible = true;
		}
		
		private function statusFlush(value:*):void
		{
			if(_rtmp.stream)
			{
				statsText.text = "帧数："+_rtmp.stream.currentFPS.toFixed(2);
			}
		}
		
		private function setUpHardware():void
		{
			hBox = new HGroup();
			
			return;
			hBox.gap = 8;
			camDp = new DropDownList();
			camDp.width = 120;
			if(cams.length>0)
			{
				cams.forEach(function(e:String,index:int,arr:Array):void
				{
					camDp.addItem({label:e,data:index});
				});
			}else{
				camDp.addItem({label:"无"});
			}
			
			micDp = new DropDownList();
			micDp.width = 120;
			if(mics.length>0)
			{
				mics.forEach(function(e:String,index:int,arr:Array):void
				{
					micDp.addItem({label:e,data:index});
				});
			}else{
				micDp.addItem({label:"无"});
			}
			
			this.addChild(hBox);
			
			hBox.addChild(new Label({label:"摄像头："}));
			hBox.addChild(camDp);
			
			hBox.addChild(new Label({label:"音频："}));
			hBox.addChild(micDp);
			
			hBox.addChild(new Button("下一步",function(e:MouseEvent):void
			{
				Logger.out(this,"摄像头和音频选择完毕！");
				previewVideo();
			}));
			
			camDp.opaqueBackground=micDp.opaqueBackground = 0x666666;
			hBox.x = (540 - hBox.width)>>1;
			hBox.y = (405 - hBox.height)>>1;
		}
		
		private function previewVideo(_cam:String = null, _mic:String = null):void
		{
			var _vars:VideoAudioVars = VideoAudioVars.getParams();
			if(Microphone.isSupported)
			{
				Logger.out(this,"使用音频",micDp?micDp.selected.label:_cam);
				mic = getMicrophoneByIndex(_mic?mics.indexOf(_mic).toString():(micDp?micDp.selected.data:null));
			}else{
				Logger.out(this,"不支持音频调用");
			}
			
			if(Camera.isSupported)
			{
				Logger.out(this,"使用摄像头",camDp?camDp.selected.label:_mic);
				cam = Camera.getCamera(_cam?cams.indexOf(_cam).toString():(camDp?camDp.selected.data:null));
				if(cam)
				{
					if(cam.muted)
					{
						cam.addEventListener(StatusEvent.STATUS,onCamStatusHandler);
						Security.showSettings(flash.system.SecurityPanel.PRIVACY);
					}else{
						showCamera();
					}
					cam.setMotionLevel(5,1000);
					cam.setLoopback(_vars.loopback);
					cam.setKeyFrameInterval(_vars.keyFrameInterval);
					cam.setMode(_vars.width,_vars.height,_vars.fps);
					cam.setQuality(_vars.bandwidth,_vars.quality);
				}
			}else{
				Logger.out(this,"不支持摄像头调用");
			}
		}
		
		override protected function volumeChange(e:Event):void
		{
			super.volumeChange(e);
			if(mic)
			{
				Logger.out(this,"发布mic音量："+_rtmp.volume);
				var soundTr:SoundTransform = mic.soundTransform;
				soundTr.volume = _rtmp.volume;
				mic.soundTransform = soundTr;
			}
		}
		
		override protected function clearlastFrame():void
		{
			super.clearlastFrame();
			//video.attachCamera(null);
			statsText.visible = false;
		}
		
		private function getMicrophoneByIndex(value:*):Microphone
		{
			var _vars:VideoAudioVars = VideoAudioVars.getParams();
			var _index:int = value?Number(value):-1;
			var _mic:Microphone = Microphone.getEnhancedMicrophone(_index);
			if(_mic)
			{
				Logger.out(this,"使用增强麦")
				//增强麦
				var seting:MicrophoneEnhancedOptions = _mic.enhancedOptions;
				seting.autoGain = false;
				seting.nonLinearProcessing = true;
				seting.echoPath = 128;
				_mic["enhancedOptions"] = seting;
			}else{
				Logger.out(this,"使用普通麦");
				//普通麦
				_mic = Microphone.getMicrophone(_index);
			}
			
			if(_mic)
			{
				_mic.codec = _vars.codec;
				if(_mic.codec == SoundCodec.SPEEX)
				{
					_mic.enableVAD = true;
					_mic.noiseSuppressionLevel = _vars.noiseSuppressionLevel;
					_mic.framesPerPacket = 1;
					_mic.encodeQuality = 10;
				}
				_mic.setLoopBack(false);
				_mic.setUseEchoSuppression(true);
				_mic.setSilenceLevel(0,2000);
				_mic.rate = _vars.rate;
			}
			return _mic;
		}
		
		private function showCamera():void
		{
			if(video)
			{
				video.visible = true;
				video.attachCamera(cam);
			}
			if(this.contains(hBox))this.removeChild(hBox);
		}
		
		override protected function initListener():void
		{
			super.initListener();
			_e.watch(Enum.STREAM_READY,streamReady);
		}
		
		override protected function start():void
		{
			if(jsData.hasOwnProperty("cam")||jsData.hasOwnProperty("mic"))
			{
				this.previewVideo(jsData["cam"],jsData["mic"]);
			}else{
				this.previewVideo();
			}
			showCamera();
			_rtmp.play(cam,mic);
		}
		
		protected function onCamStatusHandler(event:StatusEvent):void
		{
			switch(event.code)
			{
				case "Camera.Unmuted":
					showCamera();
					break;
				case "Camera.Muted":
					Logger.out(this,"摄像头调用被禁止");
					break;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			//_e.remove(Enum.STREAM_READY,streamReady);
		}
	}
}