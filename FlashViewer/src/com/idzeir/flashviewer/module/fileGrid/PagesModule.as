package com.idzeir.flashviewer.module.fileGrid
{	
	import com.idzeir.assets.FlipFolderSP;
	import com.idzeir.assets.FolderArrawSP;
	import com.idzeir.assets.PagesButSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.HGroup;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	[Event(name="change", type="flash.events.Event")]
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 25, 2014 12:15:53 AM
	 *
	 **/
	
	public class PagesModule extends Module
	{
		private var _content:HGroup;
		private var buttonBox:HGroup;
		
		private var left:Button;
		
		private var right:Button;
		
		private var _page:uint = 0;

		private var buts:Array;

		private var _curPage:uint = 1;
		
		private var _totalPages:uint;

		private var all:uint;

		private var bg:Sprite;
		
		
		public function PagesModule()
		{
			super();
			this.visible = false;
		}
		
		override protected function onAdded(event:Event):void
		{
			buts = [];
			super.onAdded(event);
			this.graphics.beginFill(0x0000ff,0);
			this.graphics.drawRect(0,0,510,50);
			this.graphics.endFill();
			buttonBox = new HGroup();
			buttonBox.valign = HGroup.MIDDLE;
			buttonBox.gap = 15;
			//this.addChild(buttonBox);
			
			createButtons();
			createArrows();
			
			_content = new HGroup();
			_content.gap = 20;
			_content.valign = HGroup.MIDDLE;
			_content.addChild(left);
			_content.addChild(buttonBox);
			_content.addChild(right);
			
			bg = new FlipFolderSP();
			//buttonBox.y = (bg.height - buttonBox.height)>>1;
			this.bg.width = 440;
			buttonBox.top = 7;
			buttonBox.left = 10;
			
			this.addChild(_content);
			
			algin();
			
		}
		
		private function createArrows():void
		{
			left = new Button("");
			var lbl:Sprite = new FolderArrawSP();
			lbl.scaleY = -1;
			lbl.rotation = 90;
			left.bglayer = lbl;
			
			right = new Button("");
			var rbl:Sprite = new FolderArrawSP();
			rbl.rotation = 90;
			rbl.x = rbl.width;
			right.bglayer = rbl;
			
			left.width = right.width = 30;
			left.height = right.height = 51;
			left.buttonMode = right.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK,onClip);
			
			/*stage.addEventListener(KeyboardEvent.KEY_UP,function(ke:KeyboardEvent):void
			{
				if(ke.keyCode == Keyboard.LEFT)
				{
					
				}
			});*/
		}
		
		protected function onClip(event:MouseEvent):void
		{
			var tar:Sprite = event.target as Sprite;
			switch(tar)
			{
				case left:
					this.prePage();
					break;
				case right:
					this.nextPage();
					break;
			}
			
		}
		
		private function createButtons():void
		{
			buts.length = 0;
			for(var i:uint = 0;i<10;i++)
			{
				var but:Button = new Button((i+1).toString(),onPagesChange);
				but.userData = i;
				but.textColor = 0x000000;
				but.bglayer = drawBgLayer();
				but.over = true;
				buts.push(but);
				this.buttonBox.addChild(but);
			}
		}
		
		private function onPagesChange(e:MouseEvent):void
		{
			if(this.hasEventListener(Event.CHANGE))
			{
				var but:Button = e.currentTarget as Button;
				if(but)
				{
					this._page = but.userData;
					this.dispatchEvent(new Event(Event.CHANGE));
					reflushStatus();
				}
			}
		}
		
		private function reflushStatus():void
		{
			for each(var i:Button in this.buts)
			{
				i.selected = this.page == i.userData;
				i.textColor = (this.page == i.userData)?0xffffff:0x000000;
			}
		}
		
		private function drawBgLayer():DisplayObject
		{
			/*var sp:Shape = new Shape();
			sp.graphics.lineStyle(1,0xffffff);
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawCircle(14,14,14);
			sp.graphics.endFill();*/
			var _bg:MovieClip = new PagesButSP();
			_bg.stop();
			return _bg;
		}
		
		private function algin():void
		{
			_content.x = _content.y = 0;
			_content.x = (this.width - _content.width)>>1;
			_content.y = (this.height - _content.height)>>1;
			_content.update();
		}
		
		public function total(value:uint = 0):void
		{
			all = Math.ceil(value/8);
			_totalPages = Math.ceil(all/buts.length);
			this.left.visible = this.right.visible = _totalPages>1;
			this.visible = all>1;
			_page = 0;
			curPage = 1;
			if(this.visible)
			{
				/*this.bg.width = 440;
				buttonBox.top = 6;
				buttonBox.left = 10;*/
				this.buttonBox.addRawChildAt(bg,0);
			}else{
				if(this.buttonBox.contains(bg))this.buttonBox.removeRawChild(bg);
			}
			algin();
		}
		
		public function get page():uint
		{
			return _page;
		}
		
		public function nextPage():void
		{
			curPage++;
		}
		public function prePage():void
		{
			curPage--;
		}
		public function get curPage():uint
		{
			return this._curPage;
		}
		public function get totalPages():uint
		{
			return this._totalPages;
		}
		
		public function set curPage(value:uint):void
		{
			this._curPage = Math.min(this._totalPages,value);
			this._curPage = Math.max(1,_curPage);
			this.left.enabled = this._curPage != 1;
			this.right.enabled = this._curPage != this._totalPages;
			fillPages();
		}
		
		private function fillPages():void
		{
			for(var i:uint;i<this.buts.length;i++)
			{
				var but:Button = buts[i];
				but.label = ((this._curPage - 1)*buts.length+1+i)+"";
				but.userData = Number(but.label) - 1;
				but.visible = but.userData<this.all;
			}
			reflushStatus();
			this.buttonBox.update();
			this._content.update();
		}
	}
}