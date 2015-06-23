package com.idzeir.bussies.welcome
{
	import com.idzeir.bussies.enum.Enum;
	import com.idzeir.bussies.manager.ManagerModule;
	import com.idzeir.bussies.player.PlayerModule;
	import com.idzeir.core.utils.Utils;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class WelcomeScreen extends Sprite
	{
		private var _keys:Dictionary;
		private var _delay:int;
		
		private var _title:TextField;
		
		public function WelcomeScreen()
		{
			super();
			_title = new TextField();
			_title.autoSize = "left"
			var tf:TextFormat = new TextFormat(null,40,0xffffff,true);
			_title.defaultTextFormat = tf;
			_title.filters = [new BlurFilter(1,1,1),new GlowFilter(0xff0000,.5,4,4,4,5)];
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_title.mouseEnabled = false;
			_title.selectable = false;
		}
		
		protected function onAdded(event:Event):void
		{
			this._keys = new Dictionary(true)
			clearTimeout(_delay);
			_delay =  setTimeout(toNormal,3000);
			
			createWelcome()
		}
		
		private function createWelcome():void
		{
			drawBglayer();
			_title.text = "welcome to iPlayer";
			_title.x = (stage.stageWidth-_title.width)>>1;
			_title.y = (stage.stageHeight - _title.height)>>1;
			this.addChild(_title);
			
			this.addCheatKey();
		}
		
		private function drawBglayer():void
		{
			var colors:Array = [0xffffff,0xffffff];
			var alphas:Array = [0,.25];
			var ratios:Array = [0x00,0xff];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth,stage.stageHeight);
			matrix.rotate(Math.PI/2);
			
			this.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
			this.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			this.graphics.endFill();
		}
		
		private function toNormal():void
		{
			trace("进入正常播放模式");
			this.clearCheatKey();
			this.parent.removeChild(this);
			Utils.mediator.send(Enum.CHANGE_SCREEN,PlayerModule);
		}
		
		private function clearCheatKey():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		private function addCheatKey():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			_keys[event.keyCode] = false;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			_keys[event.keyCode] = true;
			if(_keys[Keyboard.SHIFT]&&_keys[Keyboard.ENTER]&&_keys[Keyboard.CONTROL])
			{
				clearTimeout(_delay);
				this.clearCheatKey();
				trace("管理者模式");
				this.parent.removeChild(this);
				Utils.mediator.send(Enum.CHANGE_SCREEN,ManagerModule);
			}
		}
	}
}