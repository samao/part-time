package com.idzeir.view 
{
	import com.greensock.easing.Circ;
	import com.greensock.TweenMax;
	import com.idzeir.utils.Utils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class LibPanel extends Sprite 
	{
		static private var instance:LibPanel;
		
		private var _show:Boolean = true;
		
		private var selected:AddGIFTButton;
		
		private var _icanvas:ICanvas;
		
		public function LibPanel() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		static public function getLib():LibPanel
		{
			if (!instance)
			{
				instance = new LibPanel();
			}
			return instance;
		}
		
		public function get icanvas():ICanvas
		{
			return _icanvas;
		}
		
		public function set icanvas(value:ICanvas):void
		{
			_icanvas = value;
		}
		
		public function toggle():void 
		{
			TweenMax.killTweensOf(this);
			if (_show)
			{
				TweenMax.to(this, .5, { y: -this.height, ease:Circ.easeInOut } );
			}else {
				TweenMax.to(this, .5, { y:0, ease:Circ.easeInOut } );
			}
			_show = !_show;
		}
		
		private function onAdded(e:Event):void 
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createChildren();
		}
		
		private function createChildren():void 
		{
			for (var i:uint = 0; i < 8; i++)
			{
				var addBut:AddGIFTButton = new AddGIFTButton();				
				this.addChild(addBut);
				addBut.x = i * (addBut.width + 10)+5;
				addBut.y = 0;
			}
			
			this.graphics.lineStyle(1, 0xffffff);
			this.graphics.beginFill(0x000000,.5);
			this.graphics.drawRect(0, 0, this.width+10, this.height);
			this.graphics.endFill();
			
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var tar:AddGIFTButton = e.target as AddGIFTButton;
			if (tar)
			{
				if (tar.icon)
				{
					//trace("生成图片副本");
					this._icanvas.gift = tar.icon;
					return;
				}
				var file:File = new File();
				file.addEventListener(Event.SELECT, onSelected);				
				file.browse([Utils.FILE_FILTER])
				selected = tar;
			}			
			this.mouseEnabled = false;
		}
		
		private function onSelected(e:Event):void 
		{
			var file:File = e.target as File;			
			file.removeEventListener(Event.SELECT, onSelected);	
			var loader:Loader = new Loader();			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleted);
			loader.load(new URLRequest(file.nativePath));
		}
		
		private function onCompleted(e:Event):void
		{
			LoaderInfo(e.currentTarget).removeEventListener(Event.COMPLETE, onCompleted)
			var bitmap:Bitmap = e.target.content;
			selected.setICON(bitmap);
		}
	}

}