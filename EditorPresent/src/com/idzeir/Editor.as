package com.idzeir
{
	import com.idzeir.utils.Utils;
	import com.idzeir.view.AssistPictor;
	import com.idzeir.view.Button;
	import com.idzeir.view.Canvas;
	import com.idzeir.view.LibPanel;
	import com.idzeir.view.InstrPanel;
	import com.idzeir.view.MessInfoOptionPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author idzeir
	 */
	[SWF(width="800",height="600",frameRate="24",backgroundColor="#334455")]
	public class Editor extends Sprite 
	{		
		private var canvas:Canvas;
		private var file:File;
		
		private var mban:Sprite;
		
		private var messPanel:MessInfoOptionPanel;
		
		public function Editor():void 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{	
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			Utils.valid(setUp, function():void
			{
				var txt:TextField = new TextField();
				txt.autoSize = "left";
				txt.defaultTextFormat = new TextFormat(Utils.FONT_NAME);
				txt.selectable = false;
				txt.htmlText = "<font size='20' color='#ffffff'>未授权软件版本，启动失败。</font> <font color='#ff0000'><a href='http://wpa.qq.com/msgrd?v=3&uin=181021917&site=qq&menu=yes'>QQ咨询</a></font>";
				addChild(txt);
				txt.y = (stage.stageHeight - txt.height) >> 1;
				txt.x = (stage.stageWidth -txt.width) >> 1;
			});			
		}
		
		private function setUp():void
		{
			file = new File();
			file.addEventListener(Event.SELECT, onSelected);
			
			this.addChild(AssistPictor.getAssist());
			this.addChild(LibPanel.getLib());
			stage.addEventListener(KeyboardEvent.KEY_UP, onkeyDown);
			
			canvas = new Canvas();
			LibPanel.getLib().icanvas = canvas;
			this.addChild(canvas);				
						
			var loadBGBut:Button = new Button("辅助背景", function(event:MouseEvent):void
			{				
				file.browse([Utils.FILE_FILTER]);
			});
			loadBGBut.x = this.stage.stageWidth - loadBGBut.width - 5;
			loadBGBut.y = 5;
			this.addChild(loadBGBut);
			
			var createBut:Button = new Button("生成", createXML);
			createBut.x = loadBGBut.x - createBut.width -5;
			createBut.y = 5;
			this.addChild(createBut);
			
			mban = new Sprite();
			mban.graphics.beginFill(0x000000,1);
			mban.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			mban.graphics.endFill();
			this.addChild(mban);
			this.addChild(InstrPanel.getInstr());	
			
			messPanel = new MessInfoOptionPanel();
			
			stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, Keyboard.F1));
		}
		
		private function createXML(e:MouseEvent):void
		{		
			mban.visible = true;
			mban.alpha = 1;
			this.addChild(messPanel);
			messPanel.x = (stage.stageWidth - messPanel.width) >> 1;
			messPanel.y = (stage.stageHeight - messPanel.height) >> 1;
			messPanel.okHandler = function():void
			{
				var map:Vector.<Point> = canvas.map;
				var childs:Array = [];
				for (var i:uint = 0; i < map.length; i++)
				{
					childs.push("<point x=\""+(map[i].x-AssistPictor.getAssist().x)+"\" y=\""+(map[i].y-AssistPictor.getAssist().y)+"\"/>");
				}
				var xml:XML = 	XML(<gift_shape>
									<points leftWidth="90" topHeight="0" goodsName="默认名称" backx="0" backy="0" bg={messPanel.gcName} messBg={messPanel.gName} messx={messPanel.xPos} messy={messPanel.yPos} messSize="12" messBackColor="0xFFFF00">								
									</points>
								</gift_shape>);
				
				xml.points.setChildren(new XMLList(childs.join("\n")));
				var save:File = new File();
				save.save(xml, "特效" + new Date().getTime() + ".xml");
				mban.visible = false;
				removeChild(messPanel);
			};	
			
			messPanel.noHandler = function():void
			{
				mban.visible = false;
				removeChild(messPanel);
			};
		}
		
		private function onSelected(e:Event):void
		{			
			messPanel.assisPictor = file.name;
			AssistPictor.getAssist().content = file.nativePath;				
		}
		
		private function onkeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.F2)
			{
				LibPanel.getLib().toggle();
			}else if (e.keyCode == Keyboard.F1) {
				InstrPanel.getInstr().toggle();
				canvas.visible = !canvas.visible;
				mban.visible = !canvas.visible;
				mban.alpha = .5;
			}
		}
	}
	
}