package com.idzeir.flashviewer.module.fileTree
{	
	import com.idzeir.assets.FolderArrawSP;
	import com.idzeir.assets.FolderTitleSP;
	import com.idzeir.assets.openRootSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.VGroup;
	import com.idzeir.flashviewer.bussies.common.FilterButton;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 3:52:58 PM
	 *
	 **/
	
	public class SecondTree extends Module
	{
		protected var _content:VGroup;

		private var up:Button;

		private var down:Button;
		
		private var rootBut:Button;
		
		private var _curPage:uint = 1;
		
		private var _totalPages:uint;
		
		private var buttons:Array;
		private var fileMap:Array = [];

		private var p:Point;

		private var _select:*;
		
		private var hasDefault:Boolean;
		
		private var _pFile:File;
		
		public function SecondTree()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			//初始化
			_content = new VGroup();
			_content.gap = 8;
			this.addChild(_content);
			
			up = new Button("");
			up.bglayer = new FolderArrawSP();
			down = new Button("");
			down.bglayer = new FolderArrawSP();
			down.scaleY = -1;
			up.buttonMode = down.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK,onClip);
			
			createButtons();
		}
		
		private function createButtons():void
		{
			buttons = new Array();
			for(var i:uint = 0;i<8;i++)
			{
				var but:FilterButton = new FilterButton(" ",this.showFile);
				but.over = true;
				but.textColor = 0xffffff;
				but.bglayer = new FolderTitleSP();
				buttons.push(but);
			}
		}
		
		protected function onClip(event:MouseEvent):void
		{
			var tar:Sprite = event.target as Sprite;
			switch(tar)
			{
				case up:
					this.prePage();
					break;
				case down:
					this.nextPage();
					break;
				case rootBut:
					_pFile&&_e.send(Enum.OPEN_ROOT,_pFile);
					break;
			}
		}
		
		public function openTree(value:Array,_p:Point=null,pFile:File = null):void
		{
			_pFile = pFile;
			fileMap.length = 0;
			p = _content.globalToLocal(_p?_p:new Point());
			
			var total:uint = 0;
			for(var i:uint=0;i<value.length;i++)
			{
				var file:File = value[i];
				if(!file.isDirectory)
				{
					continue;
				}
				fileMap.push(file)
			}
			
			if(fileMap.length==0)
			{
				this._e.send(Enum.ERROR_INFO,"未找到二级分类目录");
				return;
			}
			initPagesInfo();
			this.curPage = 1;
			
			this._content.top = 7;
			down.x = up.x = 16;
			up.y = - 15;
			down.y = 317;
			
			rootBut = new Button("");
			rootBut.bglayer = new openRootSP();
			rootBut.x = 87;
			rootBut.y = 311;
			
			this.addChild(up);
			this.addChild(down);
			
			this.addChild(rootBut);
		}
		
		private function showFile(e:MouseEvent):void
		{
			var but:Button = e.currentTarget as Button;
			var sFileList:Array = (but.userData as File).getDirectoryListing();
			_e.send(Enum.SHOW_FILES,[sFileList,but.userData]);
			_select = but.userData;
			reflushStatus();
		}
		
		private function reflushStatus():void
		{
			for each(var i:Button in this.buttons)
			{
				if(i.userData == _select)
				{
					i.selected = true;
					i.textColor = 0xffffff;
					continue;
				}
				i.selected = false;
				i.textColor = 0x000000;
			}
		}
		
		/**
		 * 初始化页数
		 */		
		private function initPagesInfo():void
		{
			this._totalPages = Math.ceil(this.fileMap.length/this.buttons.length);
			this._curPage = 1;	
			this.up.visible = this.down.visible = this.totalPages>1;
		}
		
		private function fillTrees():void
		{
			var _dpt:Array = [];
			this._content.removeChildren();
			var curMaps:Array = this.fileMap.concat().slice(this.buttons.length*(this._curPage-1));
			var total:uint = 0;
			this.buttons.forEach(function(e:Button,index:int,arr:Array):void
			{
				e.visible = false;
			});
			if(curMaps.length==0)return;
			
			var aniButs:Array = [];
			for(var i:uint=0;i<buttons.length;i++)
			{
				if(i>=curMaps.length)
				{
					break;
				}
				var file:File = curMaps[i];
				var but:Button = (buttons[i] as Button);
				but.userData = file;
				but.visible = true;
				but.label = file.name;
				_content.addChild(but);
				aniButs.push(but);
			}
			
			if(!hasDefault)
			{
				hasDefault = true;
				aniButs.length>=0&&setDefaultButton(aniButs[0]);
			}
			
			aniButs.forEach(function(e:Button,index:int,arr:Array):void
			{
				Utils.tween.fromTo(e,.5,{alpha:0,x:-20},{alpha:1,x:0});
			});
			reflushStatus();
		}
		
		/**
		 * 设置默认显示 
		 * @param param0
		 * 
		 */		
		private function setDefaultButton(but:Button):void
		{
			but.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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
			this.up.enabled = this._curPage != 1;
			this.down.enabled = this._curPage != this._totalPages;
			fillTrees();
		}
	}
}