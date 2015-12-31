package com.idzeir.flashviewer.module.fileTree
{	
	import com.idzeir.assets.FileBackgroundBD;
	import com.idzeir.assets.FolderArrawSP;
	import com.idzeir.assets.FolderTitleSP;
	import com.idzeir.assets.openRootSP;
	import com.idzeir.assets.reflushFolderSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Button;
	import com.idzeir.core.view.Logger;
	import com.idzeir.core.view.VGroup;
	import com.idzeir.flashviewer.bussies.common.FilterButton;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 11:09:33 AM
	 *
	 **/
	
	public class FileTreeModule extends Module implements IFlip
	{

		private var file:File;

		private var fileMap:Array = [];

		private var buttons:Array;

		private var butsBox:VGroup;

		private var secondTree:SecondTree;

		private var _curPage:uint = 1;

		private var _totalPages:uint;

		private var up:Button;

		private var down:Button;
		
		private var rootBut:Button;

		private var _selected:*;

		private var hasDefault:Boolean;

		private var reflushRoot:Button;
		
		private var reflushSubFolder:Button;
		
		/**
		 * 界面初始化标识 
		 */		
		private var __READY__:Boolean = false;

		public function FileTreeModule()
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
			super.onAdded(event);
			file = new File(File.applicationDirectory.nativePath.toString()+"\/source");
			if(!file.exists)
			{
				Logger.out(this,"安装目录下未发现source目录");
				_e.send(Enum.NO_FOLDER_EXIST,"安装目录下未发现source目录");
				return;
			}
			file.addEventListener(FileListEvent.DIRECTORY_LISTING,function(e:FileListEvent):void
			{			
				parseTree(e.files);
			});
			file.getDirectoryListingAsync();
			
			this.x = 38;
			this.y = 162;
			createButtons();
			createFlipArrows();
			
			this._e.send(Enum.PHOTO,file);
			
			this._e.watch(Enum.OPEN_ROOT,function(value:File):void
			{
				Logger.out(this,"打开文件夹",decodeURI(value.url));
				try{
					value.openWithDefaultApplication();
				}catch(e:Error){
					//trace(e.message);
					_e.send(Enum.ERROR_INFO,"操作系统禁止此权限运行");
				}
			});
			
			reflushRoot = new Button("",function():void
			{
				if(file.exists)
				{
					secondTree.hasDefault = hasDefault = false;
					file.getDirectoryListingAsync();
				}
			});
			reflushRoot.over = true;
			reflushRoot.bglayer = new reflushFolderSP();
			
			reflushSubFolder = new Button("",function():void
			{
				secondTree.hasDefault = false;
				for each(var i:Button in buttons)
				{
					if(i.userData == _selected)
					{
						i.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
						return;
					}
				}
			});
			reflushSubFolder.over = true;
			reflushSubFolder.bglayer = new reflushFolderSP();
		}
		
		private function createFlipArrows():void
		{
			up = new Button("");
			up.bglayer = new FolderArrawSP();
			up.x = 18;
			up.y = -63;
			this.addChild(up);
			down = new Button("");
			down.bglayer = new FolderArrawSP();
			down.scaleY = -1;
			down.x = 18;
			down.y = 267;
			this.addChild(down);
			
			rootBut = new Button("");
			rootBut.bglayer = new openRootSP();
			rootBut.over = true
			rootBut.x = 90;
			rootBut.y = 260;
			this.addChild(rootBut);
			up.buttonMode = down.buttonMode = true;
			
			this.addEventListener(MouseEvent.CLICK,onClip);
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
					_e.send(Enum.OPEN_ROOT,file);
					break;
			}
		}
		
		private function createButtons():void
		{
			buttons = new Array();
			for(var i:uint = 0;i<8;i++)
			{
				var but:FilterButton = new FilterButton(" ",this.openDirectory);
				but.over = true;
				but.textColor = 0xffffff;
				but.bglayer = new FolderTitleSP();
				buttons.push(but);
			}
			butsBox = new VGroup();
			butsBox.gap = 8;
			butsBox.top = 8;
			secondTree = new SecondTree();
		}
		
		private function parseTree(files:Array):void
		{					
			fileMap.length = 0;			
			
			var total:uint = 0;
			for(var i:uint=0;i<files.length;i++)
			{
				var file:File = files[i];
				if(file.isDirectory)
				{
					fileMap.push(file);
				}
			}	
			if(fileMap.length==0)
			{
				this._e.send(Enum.ERROR_INFO,"未找到source目录，或者没有分类一级目录");
				return;
			}
			initPagesInfo();
			
			if(!__READY__){
				__READY__ = true;
				this.addChild(butsBox);
				this.addChild(secondTree);
				secondTree.y = this.butsBox.y = -50;
				secondTree.x = this.butsBox.x + 93 + 30;
				
				var boxBgd:FileBackgroundBD = new FileBackgroundBD();
				
				var boxBg:Bitmap = new Bitmap(boxBgd);
				var secondBg:Bitmap = new Bitmap(boxBgd);
				boxBg.width = secondBg.width = 113;
				boxBg.height = secondBg.height = 340;
				boxBg.x = - 12;
				secondBg.x = 110;
				boxBg.y = secondBg.y = - 70;
				this.addChildAt(secondBg,0);
				this.addChildAt(boxBg,0);
				
				reflushRoot.y = boxBg.y;
				reflushRoot.x = boxBg.x;
				this.addChild(reflushRoot);
				
				reflushSubFolder.x = secondBg.x;
				reflushSubFolder.y = secondBg.y;
				this.addChild(reflushSubFolder);
			}
			this.curPage = 1;
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
		
		private function openDirectory(e:MouseEvent):void
		{
			var but:Button = e.currentTarget as Button;
			
			var stagePos:Point = this.localToGlobal(new Point(but.x+but.width*.5,but.y+but.height*.5));
			var sFileList:Array = (but.userData as File).getDirectoryListing();
			secondTree.data = {openTree:[sFileList,stagePos,but.userData]};
			
			_selected = but.userData;
			reflushStatus();
		}
		
		private function reflushStatus():void
		{
			for each(var i:Button in this.buttons)
			{
				if(i.userData == _selected)
				{
					i.selected = true;
					i.textColor = 0xffffff;
					continue;
				}
				i.selected = false;
				i.textColor = 0x000000;
			}
		}
		
		private function fillTrees():void
		{
			this.butsBox.removeChildren();
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
				var but:FilterButton = (buttons[i] as FilterButton);
				but.userData = file;
				but.visible = true;
				but.label = file.name;
				butsBox.addChild(but);
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
		private function setDefaultButton(but:FilterButton):void
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