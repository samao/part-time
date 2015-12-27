package com.idzeir.flashviewer.module.guide
{	
	import com.idzeir.core.view.HGroup;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	
	/**
	 * ...
	 * @author: iDzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Dec 27, 2015 4:14:25 PM
	 *
	 **/
	
	public class HelpPages extends Sprite
	{
		private var loader:Loader;
		
		private var _group:Array;
		
		private var _bigPic:HelpView;
		
		private var _buts:Vector.<Sprite> = new Vector.<Sprite>();
		
		public function HelpPages()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			var file:File = File.applicationDirectory.resolvePath("help");
			file.addEventListener(FileListEvent.DIRECTORY_LISTING,function(e:FileListEvent):void
			{
				var map:Array = e.files;
				map.sortOn("name");
				group = map;
			});
			file.getDirectoryListingAsync();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void
			{
				
			});
		}
		
		private function set group(value:Array):void
		{
			_group = value;
			
			_bigPic ||= new HelpView();
			
			this.addChildAt(_bigPic,0);
			
			_bigPic.url = value[0].url;
			
			var hGroup:HGroup = new HGroup();
			
			_group.forEach(function(e:File,index:int,arr:Array):void
			{
				var doit:Sprite = createDoit();
				doit.name = e.url;
				hGroup.addChild(doit);
			});
			
			this.addChild(hGroup);
			hGroup.x = stage.stageWidth - hGroup.width>>1;
			hGroup.y = stage.stageHeight - hGroup.height - 3;
			
			this.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
			{
				if(vaild(evt.target.name))
				{
					_bigPic.url = (evt.target.name);
					reflush(evt.target as Sprite);
				}
			});
			
			reflush(_buts[0]);
		}
		
		private function vaild(url:String):Boolean
		{
			for each(var i:File in _group)
			{
				if(i.url == url)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function createDoit():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.buttonMode = true;
			sp.graphics.beginFill(0xFF0000);
			sp.graphics.drawCircle(0,0,5);
			sp.graphics.endFill();
			_buts.push(sp);
			return sp;
		}
		
		private function reflush(value:Sprite):void
		{
			_buts.forEach(function(e:Sprite,index:int,arr:Vector.<Sprite>):void
			{
				e.graphics.clear();
				e.graphics.beginFill(e==value?0xFF0000:0xFFFFFF);
				e.graphics.drawCircle(0,0,5);
				e.graphics.endFill();
			});
		}
	}
}