package com.idzeir.view
{
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.events.InfoEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	/**
	 * 提示信息
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class WeakTips extends Sprite implements IRender
	{
		private var _info:TextField;
		private var _delayid:int;
		
		public function WeakTips()
		{
			super();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			_info = new TextField();
			var tf:TextFormat = new TextFormat("宋体,微软雅黑",14);
			tf.letterSpacing = 3;
			_info.defaultTextFormat = tf;
			_info.autoSize = "left";
			_info.textColor = 0xffffff;
			_info.alpha = .8;
			this.addChild(_info);
			
			G.e.addEventListener(InfoEvent.SPREAD_INFO,showTips);
		}
		
		private function showTips(e:InfoEvent):void
		{
			if(e.info.code == Enum.ACTION_SHOW_TIPS)
			{
				this.visible = true;
				_info.htmlText = e.info.data;
				drawBorder();
				resize();
				G.t.fromTo(this,.5,{alpha:0.5},{alpha:1});
				
				clearTimeout(_delayid);
				_delayid = setTimeout(function():void
				{
					visible = false;
				},1500);
			}
		}
		
		private function drawBorder():void
		{
			var gap:int = 8;
			this.graphics.clear();
			//this.graphics.lineStyle(1, 0xffffff, .5);
			this.graphics.beginFill(0x000000, .6);
			this.graphics.drawRect(-gap, -gap, _info.width + 2 * gap, _info.height + 2 * gap);
			this.graphics.endFill();
		}
		
		public function get warp():DisplayObject
		{
			return this;
		}
		
		public function resize():IRender
		{
			if(stage)
			{
				x = stage.fullScreenWidth - this.width>>1;
				//y = (stage.fullScreenHeight - this.height - 20)
			}
			
			return this;
		}
	}
}