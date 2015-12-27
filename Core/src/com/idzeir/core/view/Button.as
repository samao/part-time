package com.idzeir.core.view 
{
	import com.idzeir.core.utils.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class Button extends Sprite 
	{
		private var _label:String;
		protected var txt:Label;
		
		public var userData:*;
		
		private var _bglayer:DisplayObject;
		private var _selected:Boolean = false;
		
		private const OVER:String = "over";
		private const OUT:String = "out";
		private const SELECT:String = "select";
		
		private var _bgColor:uint = 0xFFFFFF;
		
		private static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter(
			[
				0.3086, 0.6094, 0.082, 0, 0, 
				0.3086, 0.6094, 0.082, 0, 0, 
				0.3086, 0.6094, 0.082, 0, 0,
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1]); 

		private var _status:String = OUT;
		
		public function Button(label:String,handler:Function=null) 
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			_label = label
			if (handler!=null)
			{
				this.addEventListener(MouseEvent.CLICK, handler);
			}
			
			createChildren();
		}
		
		private function createChildren():void 
		{
			txt = new Label({maxW:80});
			txt.defaultTextFormat = new TextFormat(Utils.FONT_NAME,null,0x000000);
			txt.autoSize = "left";
			this.addChild(txt);
			label = _label;	
		}
		
		public function set bgColor(value:uint):void
		{
			_bgColor = value;
			label = _label;
		}
		
		public function set over(bool:Boolean):void
		{
			if(bool)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT,overHandler);
			}else{
				this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT,overHandler);
			}
		}
		protected function overHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER:
					status = OVER;
					break;
				case MouseEvent.MOUSE_OUT:
					status = OUT;
					break;
			}
		}
		
		public function set status(value:String):void
		{
			_status = value;
			if(this._bglayer)
			{
				var clip:MovieClip = this._bglayer as MovieClip;
				
				if(clip)
				{
					if(value == OVER)
					{
						clip.gotoAndStop(OVER);
					}else if(value == OUT){
						if(this._selected)
						{
							clip.gotoAndStop(SELECT);
						}else{
							clip.gotoAndStop(OUT);
						}						
					}else{
						clip.gotoAndStop(SELECT);
					}
				}
			}
		}
		
		public function get label():String
		{
			return txt.text;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			txt.htmlText = value;
			if(!_bglayer)
			{
				this.graphics.clear();
				this.graphics.beginFill(_bgColor);
				this.graphics.drawRoundRect(0, 0, this.width+4, this.height, 5, 5);
				this.graphics.endFill();
			}else{
				txt.width = _bglayer.width - 6;
			}
			
			algin();
		}
		
		public function set bglayer(value:DisplayObject):void
		{
			if(_bglayer)
			{
				this.removeChild(_bglayer);
			}
			_bglayer = value;
			if(_bglayer)
			{
				this.graphics.clear();
				this.addChildAt(value,0);
				this.status = _status;
				algin();
			}
		}
		
		private function algin():void
		{
			txt.x = 0;
			txt.y = 0;
			txt.y = (height - txt.height)*.5;
			txt.x = (width - txt.width)*.5;
		}
		
		public function set textColor(value:Number):void
		{
			this.txt.textColor = value;
		}
		
		public function set enabled(bool:Boolean):void
		{
			if(!bool)
			{
				this.filters = [GRAY_FILTER];
				this.mouseEnabled = false;
			}else{
				this.filters = [];
				this.mouseEnabled = true;
			}
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(value)
			{
				this.status = SELECT;
			}else{
				this.status = OUT;
			}
		}

	}

}