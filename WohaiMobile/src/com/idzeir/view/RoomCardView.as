package com.idzeir.view
{
	import com.idzeir.buissnes.Enum;
	import com.idzeir.buissnes.G;
	import com.idzeir.core.view.Label;
	import com.idzeir.events.InfoEvent;
	import com.idzeir.manager.IRoomMgr;
	import com.idzeir.vo.RoomInfoVo;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * 房间卡片ui
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class RoomCardView extends Sprite implements IRoomCard
	{

		private var _name:Label;
		private var _roomInfo:RoomInfoVo;
		private var _pic:Picture;

		private var _mgr:IRoomMgr;

		private var _total:TextField;
		
		private var _parent:DisplayObjectContainer;

		public function RoomCardView()
		{
			super();
			this.mouseChildren = false;
			_name = new Label();
			var tf:TextFormat = new TextFormat("微软雅黑", 12, 0xffffff, false);
			tf.align = TextFormatAlign.CENTER;
			_name.defaultTextFormat = tf;

			_total = new TextField();
			_total.autoSize = "left";
			_total.defaultTextFormat = tf;

			this.addEventListener(TouchEvent.TOUCH_TAP, function(e:TouchEvent):void
			{
				e.stopPropagation();
				e.stopImmediatePropagation();
				G.e.dispatchEvent(new InfoEvent(InfoEvent.SPREAD_INFO, {code:Enum.ACTION_INTO_ROOM, data:_roomInfo}));
			});
			_pic = new Picture();

			this.addChild(_pic);

			this.addChild(_name);
			_name.maxWidth = _pic.width;

			this.addChild(_total);
			_name.filters = _total.filters = [new DropShadowFilter(1,45,0x000000,1,1,2)];
		}

		public function set room(value:RoomInfoVo):void
		{
			this.visible = true;
			_roomInfo = value;
			_name.text = value.nickname;
			_pic.roomvo = value;

			//_name.y = (_pic.height - _name.height);
			//_name.x = 0;//(_pic.width - _name.width) >> 1;

			_total.htmlText = "<font color='#ffFFFF' size='10'>人数 : " + value.usercount + "</font>";
			_total.y = _pic.height - _total.height;
			_total.x = (_pic.width - _total.width);
			_parent&&_parent.addChild(this);
		}

		public function mgr(value:IRoomMgr,_parent:DisplayObjectContainer):IRoomCard
		{
			_mgr = value;
			this._parent = _parent;
			this.visible = false;
			return this;
		}

		public function dispose():void
		{
			if (stage)
			{
				this.parent && this.parent.removeChild(this);
			}
			_mgr && _mgr.recyle(this);
		}

		public function get warp():DisplayObject
		{
			return this;
		}
	}
}