package com.idzeir.flashviewer.module.fileGrid
{	
	import com.idzeir.assets.FileBackgroundBD;
	import com.idzeir.assets.FolderArrawSP;
	import com.idzeir.assets.openRootSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 20, 2014 10:46:40 PM
	 *
	 **/
	
	public class FileGridModule extends Module
	{
		private const GAP:uint = 20;

		private var cardsBox:Sprite;
		
		private var _fileMaps:Array = [];

		private var pages:PagesModule;
		
		private var rootBut:Button;
		
		private var _pFile:File;
		
		public function FileGridModule()
		{
			super();
		}
		
		override public function onload():void
		{
			super.onload();
			Logger.out(this," 模块加载完成添加到舞台");
		}
		
		override protected function onAdded(event:Event):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			var bg:Bitmap = new Bitmap(new FileBackgroundBD());
			bg.width = 720;
			bg.height = 400;
			bg.x = -20;
			//bg.y = -35;
			this.addChild(bg);
			
			rootBut = new Button("",function():void
			{
				_pFile&&_e.send(Enum.OPEN_ROOT,_pFile);
			});
			rootBut.bglayer = new openRootSP();
			rootBut.over = true;
			rootBut.x = bg.x + bg.width - rootBut.width + 2;
			rootBut.y = bg.y + bg.height - rootBut.height + 2;
			this.addChild(rootBut);
			
			//this.graphics.beginFill(0x000000,.6);
			//this.graphics.drawRect(0,0,680,380);
			//this.graphics.endFill();
			this.x = 300;
			this.y = 30;
			
			cardsBox = new Sprite();
			this.addChild(cardsBox);
			
			createFileCards();
			
			//createFlipArrows();
		}
		
		private function createFlipArrows():void
		{
			var left:FolderArrawSP = new FolderArrawSP();
			left.width = 230;
			left.height = 19;
			left.scaleY = -1;
			left.rotation = 90;
			left.y = 90;
			left.x = -30;
			this.addChild(left);
			var right:FolderArrawSP = new FolderArrawSP();
			right.width = 230;
			right.height = 19;
			right.rotation = 90;
			right.y = 90;
			right.x = 715;
			this.addChild(right);
		}
		
		private function createFileCards():void
		{
			var row:uint = (this.width+GAP)/(FileCard.CARD_WIDTH+GAP);
			var raw:uint = (this.height+GAP)/(FileCard.CARD_HEIGHT+GAP);
			
			for(var i:uint = 0;i<raw;i++)
			{
				for(var j:uint = 0;j<row;j++)
				{
					var _card:FileCard = new FileCard();
					_card.visible = false;
					cardsBox.addChild(_card);
					_card.x = j*(FileCard.CARD_WIDTH+GAP);
					_card.y = i*(FileCard.CARD_HEIGHT+GAP);
					_card.setXY(_card.x,_card.y);
				}
			}
			
			pages = new PagesModule();
			pages.addEventListener(Event.CHANGE,onPageChange);
			pages.x = 451 - 350;
			pages.y = 447 - 25;
			this.addChild(pages);
		}
		
		protected function onPageChange(event:Event):void
		{
			//trace("暂时也：",pages.page);
			this.selected(null);
			this.gotoPage(pages.page);
		}
		
		public function clearCards():void
		{
			clearCardsBox();
		}
		
		public function showFiles(...arg):void
		{
			_fileMaps.length = 0;
			var fMap:Array = arg[0];
			_pFile = arg[1];
			
			fMap.forEach(function(e:File,index:int,arr:Array):void
			{
				if(e.extension=="swf")
				{
					_fileMaps.push(e);
				}
			});
			if(_fileMaps.length==0)
			{
				Logger.out(this,"二级目录",_pFile.url," 中未发现swf文件")
				//_e.send(Enum.ERROR_INFO,"该目录下未找到swf文件");
				clearCardsBox();
				return;
			}
			pages.data = {total:[_fileMaps.length]};
			gotoPage(0);
		}
		
		private function clearCardsBox():void
		{
			var len:uint = cardsBox.numChildren;
			for(var i:uint = 0;i<len;i++)
			{
				(cardsBox.getChildAt(i) as FileCard).visible = false;
			}
		}
		
		public function gotoPage(value:uint):void
		{
			var total:uint = 0;
			var len:uint = cardsBox.numChildren;
			for(var i:uint = 0;i<len;i++)
			{
				(cardsBox.getChildAt(i) as FileCard).visible = false;
			}
			
			var curMaps:Array = this._fileMaps.concat().slice(len*value);
			var count:Number = Math.min(curMaps.length,len);
			var aniButs:Array = [];
			for(i = 0;i<count;i++)
			{
				var file:File = (curMaps[i] as File);
				var card:FileCard = (cardsBox.getChildAt(total++) as FileCard)
				card.visible = true;
				card.data = {"info":[{name:file.name,url:file.nativePath}]};
				aniButs.push(card);
			}
			
			aniButs.forEach(function(e:FileCard,index:int,arr:Array):void
			{
				Utils.tween.fromTo(e,.5,{alpha:.5,x:cardsBox.width>>1,y:cardsBox.height>>1},{alpha:1,x:e.OX,y:e.OY});
			});
		}
		
		public function selected(url:String):void
		{
			for(var i:uint = 0;i<this.cardsBox.numChildren;i++)
			{
				var card:FileCard = this.cardsBox.getChildAt(i) as FileCard;
				if(card&&card.url == url&&card.visible)
				{
					card.selected = true;
				}else{
					card.selected = false;
				}
			}
		}
	}
}