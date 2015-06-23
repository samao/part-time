package com.idzeir.core.view
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="select", type="flash.events.Event")]
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-13  下午4:00:19
	 */
	public class List extends Sprite
	{
		private var _max:uint;
		private var itemRender:Class;
		
		private var _gap:uint=0;
		
		protected var itemBox:Sprite;
		
		protected var dictionary:Dictionary=new Dictionary(true);
		
		private var _selected:Object;
		
		protected var content:Sprite;		
		
		private var scrollBar:VScrollBar;

		private var _maxHeight:Number=100;
		
		private var _mask:Shape;

		private var _maxWidth:Number=100;
		
		private var isline:Boolean=false;
		
		private var selectedTarget:IItemRender;
		
		/**
		 *列表组件 
		 * @param max 显示限制
		 * @param isLine 配置第一个参数max是否为行数限制
		 * <li>1.max=0并且isLine=false时不限制高度</li>
		 * <li>2.max=0并且isLine=true 时候限制最小单行显示</li>
		 * @param itemRender 自定义Item皮肤，默认选用Label
		 * 
		 */		
		public function List(max:uint=0,isLine:Boolean=false,itemRender:Class=null)
		{
			super();	

			isline=isLine;
			this._max=isline?Math.max(max,1):max;
			_maxHeight=max;
			this.itemRender=itemRender!=null?itemRender:ListItemRenderer;
			
			itemBox=new Sprite();			
			
			_mask=new Shape();
			content=new Sprite();
			
			content.addChild(itemBox);
			this.addChild(_mask);
			
			
			
			this.addChild(content);
			
			drawOverBody();
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			
			
			scrollBar=new VScrollBar(null,onScroll);
			scrollBar.policy="auto";
			
			if(this.isline||!this.isline&&this._max!=0)
			{				
				content.mask=_mask;
				this.addChild(scrollBar);
			}
		}
		
		private function onScroll(e:Event):void
		{
			content.y=-scrollBar.value;
			if(this.willTrigger(ProgressEvent.PROGRESS))
			{
				this.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,this.scrollBar.value,this.scrollBar.maximum));
			}
		}
		
		protected function onOut(event:MouseEvent):void
		{
			var tar:IItemRender=event.target as IItemRender ;			
			if((tar is IItemRender))
			{
				IItemRender(tar).onMouseOut();
			}
		}
		
		protected function onOver(event:MouseEvent):void
		{
			var tar:IItemRender=event.target as IItemRender ;			
			if((tar is IItemRender))
			{
				IItemRender(tar).onMouseOver();
			}
		}
		
		/**
		 *子类覆盖重绘鼠标划入和选中效果 
		 * 
		 */		
		protected function drawOverBody():void
		{
			_mask.graphics.beginFill(0x000000,0);
			_mask.graphics.drawRect(0,0,this._maxWidth,this._maxHeight);
			_mask.graphics.endFill();			
		}
				
		/**
		 *设置组件数据 
		 * @param data 
		 * 
		 */		
		public function set dataProvider(data:Array):void
		{
			clear();
			for each(var i:Object in data)
			{
				addItem(i);
			}			
		}
		
		public function addItem(data:Object):DisplayObject
		{
			var item:DisplayObject=new itemRender();			
			IItemRender(item).startUp(data);
			Sprite(item).mouseChildren=false;			
			Sprite(item).graphics.beginFill(0x000000,0);
			Sprite(item).graphics.drawRect(0,0,width,item.height);
			Sprite(item).graphics.endFill();
			itemBox.addChild(item);
			
			dictionary[item]=data;
			
			reBuild();
			if(!this.hasEventListener(MouseEvent.CLICK))
			{
				this.addEventListener(MouseEvent.CLICK,clickHandler);
			}
			
			return item
		}
		
		/**
		 * 以传入的数据object中的键值删除list中显示对象 
		 * @param key 键值
		 * @param value 比较的值
		 * 
		 */		
		public function removeItemByKey(key:String,value:*):void
		{
			for(var i:* in this.dictionary)
			{
				if(this.dictionary[i][key]==value)
				{	
					var tar:DisplayObject=i;
					delete this.dictionary[i];
					if(itemBox.contains(tar))itemBox.removeChild(tar);
					break;
				}
			}
			this.reBuild();					
		}
		/**
		 * 更新某一项 
		 * @param key 键值
		 * @param value 查找值
		 * @param newValue 新数据
		 * 
		 */		
		public function updateItem(key:String,value:*,newValue:*):void
		{
			for(var i:* in this.dictionary)
			{
				if(this.dictionary[i][key]==value)
				{
					var tar:IItemRender=i as IItemRender;
					tar.startUp(newValue);
					break;
				}
			}
		}
		/**
		 * 回去某一项的数据 
		 * @param key 键值
		 * @param value 查找值
		 * @return 
		 * 
		 */		
		public function getItem(key:String,value:*):*
		{
			for(var i:* in this.dictionary)
			{
				if(this.dictionary[i][key]==value)
				{
					return this.dictionary[i];
				}
			}
			return null;
		}
		
		protected function clickHandler(event:Event):void
		{
			var tar:DisplayObject=event.target as DisplayObject ;
			if((tar is this.itemRender)&&this.hasEventListener(Event.SELECT))
			{
				this._selected=this.dictionary[tar];
				this.dispatchEvent(new Event(Event.SELECT));
				
				if(this.selectedTarget){
					selectedTarget.unSelected();
				}
				selectedTarget=IItemRender(tar);
				IItemRender(tar).onSelected();
			}
			event.stopPropagation();
		}
		/**
		 *当前选中项的数据 
		 * @return 
		 * 
		 */		
		public function get selected():Object
		{
			return this._selected;
		}
		
		/**
		 * 行间距 
		 */		
		public function get gap():uint
		{
			return _gap;
		}
		
		public function set gap(value:uint):void
		{
			_gap = value;
			reBuild();
		}
		
		/**
		 * 列表最大显示高度 当设置了行限制时候，设置高度将无效 
		 * @param value
		 * 
		 */		
		override public function set height(value:Number):void
		{
			if(this.isline){
				//trace("设置了限制条数，当前赋值无效");
				return;
			}
			_maxHeight=value;
			_mask.height=value;
			reBuild();
		}
		
		override public function get height():Number
		{
			return _maxHeight;
		}
		
		override public function set width(value:Number):void
		{
			_maxWidth=value;
			_mask.width=value;
			reBuild();
		}
		
		override public function get width():Number
		{
			return this._maxWidth;
		}
		
		/**
		 * 列表当前数据条数 
		 * @return 
		 * 
		 */		
		public function get size():uint
		{
			return itemBox.numChildren;
		}
		
		/**
		 * 清空组件数据 
		 */		
		public function clear():void
		{
			for each(var i:* in this.dictionary)
			{
				delete this.dictionary[i];
			}			
			itemBox.removeChildren();			
			this._selected=null;
		}
		
		protected function reBuild():void
		{
			var yPos:Number=0;
			
			for(var i:uint=0;i<itemBox.numChildren;i++)
			{
				var item:DisplayObject=itemBox.getChildAt(i);
				item.y=yPos;
				yPos+=item.height+_gap;
			}
			
			if(item){
				if(this.isline)
				{
					_maxHeight=item.height*this._max+(this._max-1)*_gap;
					_mask.height=_maxHeight;
				}
			}
			
			if(this._max!=0&&!this.isline||this.isline)
			{
				scrollBar.x=_maxWidth-scrollBar.width;
				
				scrollBar.height=_maxHeight;
				
				scrollBar.setThumbPercent(_maxHeight/itemBox.height)
				scrollBar.maximum=Math.max(0,itemBox.height-_maxHeight+30);
				scrollBar.resize();
				this.isWheel=scrollBar.visible;
			}
		}
		
		/**
		 * 垂直滑动区域量 
		 * @return 
		 * 
		 */		
		public function get deltaY():Number
		{
			return Math.abs(this.scrollBar.maximum-this.scrollBar.minimum);
		}
		
		/**
		 * 鼠标中键滚动处理 
		 * @param event
		 * 
		 */		
		protected function onWheel(event:MouseEvent):void
		{			
			this.scrollBar.value-=event.delta*(this.deltaY)/50;
		}
		
		/**
		 * 显示滑动条的时候添加鼠标滑轮滚动事件 
		 * @param value
		 * 
		 */		
		private function set isWheel(value:Boolean):void
		{
			if(value&&!this.hasEventListener(MouseEvent.MOUSE_WHEEL))
			{				
				this.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			}else if(!value&&this.hasEventListener(MouseEvent.MOUSE_WHEEL)){
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			}
		}
	}
}
