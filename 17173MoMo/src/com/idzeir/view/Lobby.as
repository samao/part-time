package com.idzeir.view
{
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.events.InfoEvent;
	import com.idzeir.vo.RoomInfoVo;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;

	/**
	 * 大厅ui
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class Lobby extends Sprite implements IRender
	{

		private var _port:Rectangle;

		private var _box:Sprite;
		
		private var _cards:Vector.<IRoomCard>;

		public function Lobby()
		{
			super();
			
			_cards = new Vector.<IRoomCard>();
			_box = new Sprite();
			this.addChild(_box);

			G.e.addEventListener(InfoEvent.SPREAD_INFO, function(value:InfoEvent):void
				{
					value.info.code == Enum.ACTION_ROOM_INFO && infoReady(value.info.data);
				});
			
			var touchId:int = 0;
			_box.addEventListener(TouchEvent.TOUCH_BEGIN,function(e:TouchEvent):void
			{
				if(_box.height<=_port.height)
				{
					return;
				}
				_box.startTouchDrag(e.touchPointID,false,new Rectangle(_box.x,_port.height - _box.height,0,_box.height - _port.height));
			
				touchId = e.touchPointID;
				
				stage.addEventListener(TouchEvent.TOUCH_END,function(e:TouchEvent):void
				{
					if(touchId == e.touchPointID)
					{
						stage.removeEventListener(TouchEvent.TOUCH_END,arguments.callee);
						if(_box.height<=_port.height)
						{
							return;
						}
						_box.stopTouchDrag(e.touchPointID);
						touchId = 0;
					}
				});
			});
			
		}
		
		public function set port(value:Rectangle):void
		{
			_port = value;
			var card:IRoomCard = G.r.creatRoomCard();
			var w:int = card.warp.width;
			var h:int = card.warp.height;

			var xgap:int = 15;
			var ygap:int = 25;
			
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,value.width,value.height);
			this.graphics.endFill();
			
			var _mask:Shape = new Shape();
			_mask.graphics.beginFill(0x000000,0);
			_mask.graphics.drawRect(0,0,value.width,value.height);
			_mask.graphics.endFill();
			this.addChild(_mask);
			this.mask = _mask;
			
			/*for (var i:uint = 0; i < 1500 - h; i += (h + ygap))
			{
				for (var j:uint = 0; j < _port.width - w; j += (w + xgap))
				{
					var roomView:IRoomCard = G.r.creatRoomCard(_box);
					roomView.warp.x = j;
					roomView.warp.y = i;
					_cards.push(roomView);
				}
			}*/
			
			var roomTotal:uint = 100;
			var row:uint = (_port.width)/(w+xgap);
			
			for(var i:uint = 0;i<100;++i)
			{
				var roomView:IRoomCard = G.r.creatRoomCard(_box);
				roomView.warp.x = (i%row)*(w+xgap);
				roomView.warp.y = uint(i/row)*(h+ygap);
				_cards.push(roomView);
			}
			
			align();
		}

		private function infoReady(value:Boolean):void
		{
			if (value)
			{
				var rooms:Vector.<RoomInfoVo> = G.r.map();
				for (var i:uint = 0; i < _cards.length; i++)
				{
					var roomView:IRoomCard = _cards[i];
					if (roomView && rooms.length > i)
					{
						roomView.room = rooms[i];
					}
					else
					{
						roomView.dispose();
					}
				}
				align();
			}
			else
			{
				trace("接口调用失败");
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO,{code:Enum.ACTION_SHOW_TIPS,data:"接口调用失败[Lobby]"}));
			}
		}

		public function align():void
		{
			this._box.x = _port.width - _box.width>>1;
			this._box.y = 20; //(stage.fullScreenHeight - this.y - _box.height)>>1;
		}

		public function get warp():DisplayObject
		{
			return this;
		}

		public function resize():IRender
		{
			return this;
		}
	}
}