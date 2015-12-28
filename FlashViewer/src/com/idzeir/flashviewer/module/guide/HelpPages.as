package com.idzeir.flashviewer.module.guide
{	
	import com.idzeir.assets.HelpButSP;
	import com.idzeir.core.view.Button;
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
		
		private var _buts:Vector.<Button> = new Vector.<Button>();
		
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
				var doit:Sprite = createDoit(index);
				doit.name = e.url;
				hGroup.addChild(doit);
			});
			
			this.addChild(hGroup);
			hGroup.gap = 25;
			hGroup.x = stage.stageWidth - hGroup.width>>1;
			hGroup.y = stage.stageHeight - (stage.stageHeight - 450)/2 - 10;
			
			this.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
			{
				if(vaild(evt.target.name))
				{
					_bigPic.url = (evt.target.name);
					reflush(evt.target as Button);
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
		
		private function createDoit(value:int):Sprite
		{
			var sp:Button = new Button((value+1).toString());
			sp.buttonMode = true;
			sp.bglayer = new HelpButSP();
			_buts.push(sp);
			return sp;
		}
		
		private function reflush(value:Button):void
		{
			_buts.forEach(function(e:Button,index:int,arr:Vector.<Button>):void
			{
				e==value?e.selected = true:e.selected = false;
			});
		}
	}
}