package com.idzeir.view 
{
	import com.idzeir.utils.Utils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class MessInfoOptionPanel extends Sprite 
	{
		public var okHandler:Function;
		public var noHandler:Function;
		private var _bgTxt:InputTxt;
		private var _nameTxt:InputTxt
		private var _xTxt:InputTxt;
		private var _yTxt:InputTxt;
		private var _gap:Number = 20;
		
		public function MessInfoOptionPanel() 
		{
			super();
			
			this.createChildren();
		}
		
		private function createChildren():void 
		{
			_bgTxt = new InputTxt();
			_nameTxt = new InputTxt();
			_xTxt = new InputTxt();
			_yTxt = new InputTxt();
			_bgTxt.width = _nameTxt.width = 110;
			_xTxt.width = 30;
			_yTxt.width = 30;			
			
			var _sBgTxt:TextField = new TextField();
			_sBgTxt.text = "背景:";
			var _sNameTxt:TextField = new TextField();
			_sNameTxt.text = "卡片:";
			var _sXtxt:TextField = new TextField();
			_sXtxt.text = "坐标x:";
			var _sYtxt:TextField = new TextField();
			_sYtxt.text = "坐标y:";
			
			_sBgTxt.autoSize = _sNameTxt.autoSize = _sXtxt.autoSize = _sYtxt.autoSize = "left";
			var tf:TextFormat = new TextFormat(Utils.FONT_NAME);
			_sBgTxt.defaultTextFormat = _sNameTxt.defaultTextFormat = _sXtxt.defaultTextFormat = _sYtxt.defaultTextFormat = tf;				
			_sBgTxt.textColor = _sNameTxt.textColor = _sXtxt.textColor = _sYtxt.textColor = 0xffffff;
			
			_sBgTxt.x = _sBgTxt.y = 10;
			_bgTxt.x = _sBgTxt.x + _sBgTxt.width +_gap * .25;
			_bgTxt.y = _sBgTxt.y;
			
			_sNameTxt.y = _sBgTxt.y + _sBgTxt.height + _gap;
			_sNameTxt.x = _sBgTxt.x;
			_nameTxt.y = _sNameTxt.y;
			_nameTxt.x = _sNameTxt.x+_sNameTxt.width + _gap * .25;
			
			_sXtxt.x = _sNameTxt.x;
			_sXtxt.y = _sNameTxt.y+_sNameTxt.height + _gap;			
			_xTxt.x = _sXtxt.x+_sXtxt.width +_gap * .25;
			_xTxt.y = _sXtxt.y;
			
			_sYtxt.x = _xTxt.x + _xTxt.width + _gap;
			_sYtxt.y = _xTxt.y;			
			_yTxt.y = _sYtxt.y;
			_yTxt.x = _sYtxt.x+_sYtxt.width +_gap*.25;
			_xTxt.maxChars = _yTxt.maxChars = 3;
			_xTxt.restrict = _yTxt.restrict = "0-9";
			_xTxt.text = "100";
			_yTxt.text = "280";
			
			this.addChild(_sBgTxt);
			this.addChild(_bgTxt);
			this.addChild(_sNameTxt);
			this.addChild(_sXtxt);
			this.addChild(_sYtxt);
			this.addChild(_nameTxt);
			this.addChild(_xTxt);
			this.addChild(_yTxt);
			
			createINs();
			
			var noButton:Button = new Button("取消", function():void
			{
				if (noHandler!=null)
				{
					noHandler.apply();
				}
			});
			
			var buttonBox:Sprite = new Sprite();
			var okButton:Button = new Button("确定", function():void
			{
				if (okHandler!=null)
				{
					okHandler.apply();
				}
			})
			okButton.x = noButton.width + _gap;
			buttonBox.addChild(noButton);
			buttonBox.addChild(okButton);
			buttonBox.x = ((this.width - buttonBox.width) >> 1)+10;
			buttonBox.y = this.height +_gap+10;			
			
			this.addChild(buttonBox);
			
			this.graphics.beginFill(0x004080, .25);
			this.graphics.lineStyle(1, 0xffffff);
			this.graphics.drawRect(0, 0, this.width+20, this.height + 20);
			this.graphics.endFill();			
		}
		
		public function set assisPictor(value:String):void
		{
			this._bgTxt.text = value;
			this._nameTxt.text = value.replace(/(\.)/,"_card$1");
		}
		
		private function createINs():void 
		{
			var txt:TextField = new TextField();
			txt.autoSize = "left";
			txt.htmlText = "<font color='#ff0000'> 辅助图的名称</font>";
			
			var txt1:TextField = new TextField();
			txt1.autoSize = "left";
			txt1.htmlText = "<font color='#ff0000'> 显示信息卡背景</font>";
			
			txt.x = this._bgTxt.x + this._bgTxt.width + _gap * .25;
			txt.y = this._bgTxt.y;
			
			txt1.x = this._nameTxt.x + this._nameTxt.width + _gap * .25;
			txt1.y = this._nameTxt.y;
			this.addChild(txt);
			this.addChild(txt1);
		}
		
		public function get gcName():String
		{
			return this._nameTxt.text;
		}
		
		public function get gName():String
		{
			return this._bgTxt.text;
		}
		
		public function get xPos():String
		{
			return _xTxt.text;
		}
		
		public function get yPos():String
		{
			return _yTxt.text;
		}
	}

}