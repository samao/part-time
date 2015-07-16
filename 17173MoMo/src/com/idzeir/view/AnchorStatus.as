package com.idzeir.view
{
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.events.InfoEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;


	/**
	 * 播放用户昵称
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Nov 30, 2014 4:00:48 PM
	 *
	 **/

	public class AnchorStatus extends Sprite implements IRender
	{

		private var _name:TextField;

		public function AnchorStatus()
		{
			super();

			this.mouseChildren = false;
			this.mouseEnabled = false;
			_name = new TextField();
			_name.autoSize = "left";
			_name.textColor = 0xffffff;
			_name.defaultTextFormat = new TextFormat("微软雅黑", 14, 0xffffff, true);
			this.addChild(_name);

			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(e:InfoEvent):void
				{
					e.info.code == Enum.ACTION_INTO_ROOM && (_name.text = e.info.data.nickname);
					resize();
				});

			this.filters = [new GlowFilter(0x000000,1,1,1,1),new flash.filters.DropShadowFilter(1, 0, 0, .2), new DropShadowFilter(4, 90, 0, .2), new DropShadowFilter(1, 180, 0, .2)]
		}

		public function get warp():DisplayObject
		{
			return this;
		}

		public function resize():IRender
		{
			var ratio:Number = stage.fullScreenWidth / G.WIDTH;
			_name.x = stage.fullScreenWidth - _name.width >> 1;
			_name.y = (53 - _name.height>>1)*ratio;
			return this;
		}
	}
}