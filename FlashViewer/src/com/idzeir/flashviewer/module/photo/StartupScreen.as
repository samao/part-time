package com.idzeir.flashviewer.module.photo
{
	import com.idzeir.assets.EffectMP;
	import com.idzeir.assets.LogoSP;
	import com.idzeir.assets.ProgressBglayerSP;
	import com.idzeir.assets.ProgressMP;
	import com.idzeir.assets.StartupBglayerSP;
	import com.idzeir.assets.StartupSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class StartupScreen extends Module
	{
		private var _logo:DisplayObject;
		private var _bglayer:DisplayObject;
		
		private var _frontLayer:Sprite;
		private var _progress:MovieClip;
		private var _progressBglayer:Sprite;
		private var _eff:MovieClip;		
		
		private var _info:TextField;
		
		public function StartupScreen()
		{
			super();
			
			initChildren();
			
			//this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function initChildren():void
		{
			_bglayer ||= new StartupBglayerSP();
			_frontLayer ||= new StartupSP();
			_logo ||= new LogoSP();
			_logo.x = 30;
			_logo.y = 18;
			_eff ||= new EffectMP();
			_eff.x = 300;
			_eff.y = 200;
			
			_progressBglayer ||= new ProgressBglayerSP();
			_progressBglayer.x = 166+44;
			_progressBglayer.y = 283;
			
			_progress ||= new ProgressMP();
			_progress.gotoAndStop(1);
			_progress.x = 276+44;
			_progress.y = 388;
			
			if(!_info)
			{
				_info = new TextField();	
				_info.x = 260+44;
				_info.y = 420;
				_info.width = 400;
				_info.defaultTextFormat = new TextFormat(Utils.FONT_NAME,14,0xffff00,true);
				_info.autoSize = "center";
			}
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			
			this.addChild(_bglayer);
			this.addChild(_progressBglayer);
			this.addChild(_progress);
			this.addChild(_frontLayer);
			this.addChild(_logo);
			this.addChild(_info);
			this.addChild(_eff);
		}
		
		/**
		 * 设置进度条进度 
		 * @param value 1-100的值
		 * 
		 */		
		public function set progress(value:uint):void
		{
			this._progress.gotoAndStop(value);
			this._info.htmlText = "生成缩略图进度："+value+" %";
		}
		
		public function set info(value:String):void
		{
			this._info.htmlText = value;
			_progress.gotoAndStop(_progress.totalFrames);
		}
		/**
		 * 错误信息 
		 * @param value
		 * 
		 */		
		public function set errorInfo(value:String):void
		{
			this._info.htmlText = value;
			_progress.gotoAndStop(_progress.totalFrames);
		}
	}
}