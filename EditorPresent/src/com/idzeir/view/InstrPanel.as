package com.idzeir.view 
{
	import com.greensock.easing.Circ;
	import com.greensock.TweenMax;
	import com.idzeir.utils.Utils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class InstrPanel extends Sprite 
	{
		private var _show:Boolean = false;
		static private var instance:InstrPanel;
		
		public function InstrPanel() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			createChildren();
		}
		
		private function createChildren():void 
		{
			var txt:TextField = new TextField();
			txt.multiline = true;
			//txt.wordWrap = true;
			txt.autoSize = "left";
			txt.defaultTextFormat = new TextFormat(Utils.FONT_NAME);
			this.addChild(txt);
			txt.htmlText = "<font size='15' color='#ff0000'><b> 帮助:</b></font>";
			txt.htmlText += "<font color='#ffffff'>\t<li>F2显示隐藏顶部礼物栏</li>";
			txt.htmlText += "\t<li>F1显示隐藏帮助(开始编辑)</li>";
			txt.htmlText += "\t<li>点击生成按钮保存xml文件,保存好之后需要手动修改里面的礼物名称，以及弹出信息卡的位置</li>";
			txt.htmlText += "\t<li>辅助背景按钮可以加载一张背景图片辅助定位，图片大小800*600</li>";
			txt.htmlText += "\t<li>ctrl+鼠标点击赋值动画点，摆好动画点之后点击顶部\"+(礼物)\"按钮加载礼物图标，加载之后再次点击礼物图标预览动画</li><font>";
			txt.htmlText += "\t<li>shift+鼠标点击删除动画点</li>";
			
			this.graphics.beginFill(0x000000, .5);
			this.graphics.lineStyle(1, 0xffffff);
			this.graphics.drawRect(0, 0, this.width, this.height);
			this.graphics.endFill();
			
			this.x = -this.width;
			this.y = (stage.stageHeight - this.height) >> 1;
		}
		
		static public function getInstr():InstrPanel
		{
			if (!instance)
			{
				instance = new InstrPanel();
			}
			return instance;
		}
		
		public function toggle():void 
		{
			TweenMax.killTweensOf(this);
			if (_show)
			{
				TweenMax.to(this, .5, { x: -this.width, ease:Circ.easeInOut } );
			}else {
				TweenMax.to(this, .5, { x:(stage.stageWidth-this.width)>>1, ease:Circ.easeInOut } );
			}
			_show = !_show;
		}
	}

}