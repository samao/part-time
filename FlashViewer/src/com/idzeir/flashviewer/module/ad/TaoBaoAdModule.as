package com.idzeir.flashviewer.module.ad
{	
	import com.idzeir.assets.AdSP;
	import com.idzeir.core.bussies.Module;
	import com.idzeir.core.utils.Utils;
	import com.idzeir.core.view.Logger;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 5:06:53 PM
	 *
	 **/
	
	public class TaoBaoAdModule extends Module
	{
		private var TAO_BAO:String = "https://fengyumantian.taobao.com/";//shop111278284.taobao.com/shop/view_shop.htm";
		private var eleName:String = "banner-box";
		private var _content:Sprite;

		private var html:HTMLLoader;
		
		private var _bannerHtml:String = null;
		
		/**
		 * 广告宽高 
		 */		
		private const AD_W:uint = 350;
		private const AD_H:uint = 52;
		
		public function TaoBaoAdModule()
		{
			super();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);			
			this.buttonMode = true;
			this.mouseEnabled = true;
			
			createGUI();
			x = 30;
			y = 450;
			_content = new Sprite();
			this.addChild(_content);
			
			_content.addChild(new AdSP());
			var webUrl:TextField = new TextField();
			webUrl.defaultTextFormat = new TextFormat("微软雅黑，宋体",18,0x000000,false);
			webUrl.defaultTextFormat.letterSpacing = 2;
			webUrl.autoSize = "left";
			webUrl.htmlText = "<a href='"+TAO_BAO+"'>"+TAO_BAO+"</a>";
			webUrl.x = 20;
			webUrl.y = 30;
			_content.addChild(webUrl);
			/*
			html = new HTMLLoader();
			html.width = 1000;
			html.height = 90;
			//html.addEventListener(Event.COMPLETE,onWebComplete);
			html.addEventListener(Event.HTML_BOUNDS_CHANGE,function():void
			{
				try
				{
					var d:* = (html.window.document.getElementsByClassName(eleName));
					if(d&&d.length>0)
					{
						if(d[0].innerHTML!="")
						{
							html.removeEventListener(Event.HTML_BOUNDS_CHANGE,arguments.callee);
							var divstr:String = (d[0].innerHTML);
							loadHtmlStr(divstr);
						}
					}
				}catch(e:Error){}
			});
			html.load(new URLRequest(TAO_BAO));*/
			
			this.addEventListener(MouseEvent.CLICK,function():void
			{
				Utils.toURL(TAO_BAO);
			});
		}
		
		protected function loadHtmlStr(value:String):void
		{
			html.loadString("");
			var hso:String = value.replace("//","").replace("alt=\"\"","/");
			var xml:XML = new XML(hso);
			var imgURL:String = xml.img.@src.toString().split("\n").join("").split("\r").join("");
			Logger.out(this,imgURL);
			var loader:Loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void{});
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void
			{
				_content.addChild(loader);
				_content.width = AD_W;
				_content.height = AD_H;
				createCover(AD_W,AD_H);
			});
			loader.load(new URLRequest("http://"+imgURL));
		}
		
		private function createCover(w:uint,h:uint):void
		{
			var layer:Sprite = new Sprite();
			layer.graphics.beginFill(0xffffff,0);
			layer.graphics.drawRect(0,0,w,h);
			layer.graphics.endFill();
			addChild(layer);
		}
		
		private function createGUI():void
		{
			this.graphics.beginFill(0xc4c4c4c,0);
			this.graphics.drawRect(0,0,350,52);
			this.graphics.endFill();
		}
	}
}