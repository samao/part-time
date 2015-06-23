package com.idzeir.flashviewer.module.preview
{
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.IItemRender;
	
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	
	
	/**
	 * tab预览黑白背景切换按钮样式
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 4, 2014||10:42:12 AM
	 */
	public class TabButtonSkin extends Button implements IItemRender
	{
		private var data:*;
		
		public function TabButtonSkin(label:String="", handler:Function=null)
		{
			super(label, handler);
			var tf:TextFormat = new TextFormat("微软雅黑",12,0xffffff,false);
			this.txt.defaultTextFormat = tf;
			this.txt.filters = [new GlowFilter(0x000000,1,1,1,1),new flash.filters.DropShadowFilter(2),new BlurFilter(1,1,1)]
			var skin:Shape = new Shape();
			this.bglayer = skin;
		}
		
		public function startUp(value:Object):void
		{
			data = value;
			this.txt.text = value.label;
		}
		
		public function onMouseOver():void
		{
			this.txt.textColor = 0xff0000;
		}
		
		public function onMouseOut():void
		{
			this.txt.textColor = 0xffffff;
		}
		
		public function onSelected():void
		{
			this.txt.textColor = 0x999999;
		}
		
		public function unSelected():void
		{
			this.txt.textColor = 0xffffff;
		}
	}
}