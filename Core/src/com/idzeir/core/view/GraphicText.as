package com.idzeir.core.view
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineMirrorRegion;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;

	/**
	 * 图文混排点击
	 */
	[Event(name="textLink", type="com._17173.flash.core.components.common.GraphicTextLinkEvent")]
	
	/**
	 * 图文混排显示（包括鼠标事件）
	 * @author idzeir
	 */
	public class GraphicText extends Sprite
	{
		/**
		 * 断行宽度，默认为2000px
		 */
		private var _textWidth:uint = 2000;

		/**
		 * 行间距，默认为3px
		 */
		private var _leading:int = 3;

		/**
		 * 统一缩进
		 */
		private var _indent:int = 0;

		/**
		 * 添加到容器的显示元素
		 */
		private var _groups:Vector.<GroupElement>;

		/**
		 * 对应于groupElement 生成的block,以groupelement为key
		 */
		private var _blockHash:Dictionary;

		/**
		 * 行数据以block为key
		 */
		private var _linesHash:Dictionary;

		/**
		 * 文本行当前的位置
		 */
		private var _ypos:Number = 0;

		/**
		 * 所有显示的textline
		 */
		private var _lines:Sprite;

		/**
		 * 锁定状态下文本容纳最大行翻倍
		 * */
		private var _locked:Boolean = false;

		/**
		 * 最大容纳行数，默认为100
		 */
		private var _max:uint = 100;

		/**
		 * 激活模式为true时直接创建行,否则缓存数据
		 */
		private var _enabled:Boolean = true;

		/**
		 * 非激活状态下缓存的数据
		 */
		private var _cacheMap:Vector.<GroupElement>;

		private var _event:EventDispatcher;

		private var _overElement:ContentElement;
		
		private var _overMap:Vector.<ContentElement>;

		/**
		 * 图文混排显示对象
		 * @param	iGraphic 混排元素生成接口
		 */
		public function GraphicText(bool:Boolean = true,value:Number = 0)
		{
			super();
			_indent = value;
			_groups = new Vector.<GroupElement>();
			_overMap = new Vector.<ContentElement>();
			_blockHash = new Dictionary(true);
			_linesHash = new Dictionary(true);

			_lines = new Sprite();
			this.addChild(_lines);

			_event = new EventDispatcher(this);
			_event.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			_event.addEventListener(MouseEvent.MOUSE_OUT, overHandler);
			_event.addEventListener(MouseEvent.CLICK, onClick);
		}
		public function append(str:String,elf:ElementFormat=null):void
		{
			
		}
		public function set showLink(value:Boolean):void
		{
			
		}
		
		public function get showLink():Boolean
		{
			return false;
		}

		/**
		 * 1、设置ContentElement.eventMirror后
		 * 2、设置ContentElement.userData.event为点击派发的事件
		 */
		public function get mirror():EventDispatcher
		{
			return _event;
		}

		private function onClick(e:MouseEvent):void
		{
			var line:TextLine = e.currentTarget as TextLine;

			if(!line)
			{
				return;
			}

			var _len:uint = line.mirrorRegions.length;

			for(var i:uint = 0; i < _len; i++)
			{
				var region:TextLineMirrorRegion = line.mirrorRegions[i];
				var bounds:Rectangle = region.bounds;

				/*var lineBox:Sprite = line.parent as Sprite;
				   if(lineBox)
				   {
				   lineBox.graphics.clear();
				   lineBox.graphics.beginFill(0x0000ff,.4);
				   lineBox.graphics.drawRect(bounds.left+line.x,bounds.top+line.y,bounds.width,bounds.height);
				   lineBox.graphics.endFill();
				 }*/

				var mouseBounds:Rectangle = line.getAtomBounds(line.getAtomIndexAtPoint(e.stageX, e.stageY));

				if(bounds.intersects(mouseBounds))
				{
					var ele:ContentElement = region.element;

					if(ele.userData && ele.userData.hasOwnProperty("event"))
					{
						if(hasEventListener(GraphicTextLinkEvent.TEXT_LINK))
						{
							dispatchEvent(new GraphicTextLinkEvent(GraphicTextLinkEvent.TEXT_LINK,ele.userData["event"]));
						}
					}
				}
			}
			e.stopPropagation();
			
			rollOutLine()
		}

		private function overHandler(e:MouseEvent):void
		{
			var line:TextLine = e.currentTarget as TextLine;

			if(!line)
			{
				return;
			}
			switch(e.type)
			{
				case MouseEvent.MOUSE_OVER:
					if(Mouse.cursor == MouseCursor.AUTO&&!_overElement)
					{
						Mouse.cursor = MouseCursor.BUTTON;
						reBuildLine(line, e.localX, e.localY);
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(Mouse.cursor == MouseCursor.BUTTON)
					{
						Mouse.cursor = MouseCursor.AUTO;
						//滑出恢复
						rollOutLine();
					}
					break;
			}
		}

		private function rollOutLine():void
		{
			if(_overElement)
			{
				_lines.graphics.clear();
			}else{
				return;
			}
			var line:TextLine = _overElement.textBlock.firstLine;

			var _p:Point = new Point(line.x, line.y);
			var _b:TextBlock = _overElement.textBlock;
			var _g:GroupElement = _b.content as GroupElement;
			
			var ef:ElementFormat = _overElement.elementFormat.clone();
			var _color:int = ef.color;
			ef.color = _overElement.userData["hover"];
			_overElement.userData["hover"] = _color;
			_overElement.elementFormat = ef;
			
			removelineByTextBlock(_b);
			this.createlineFromBlock(_b, _g, _p);
			_b.releaseLineCreationData();
			_overElement = null;
		}

		private function reBuildLine(line:TextLine, localX:Number, localY:Number, color:uint = 0xff0000):void
		{
			var _len:uint = line.mirrorRegions.length;
			var lineBox:Sprite = line.parent as Sprite;

			if(!lineBox)
			{
				return;
			}

			//第一行的坐标
			var _points:Point = new Point();

			for(var i:uint = 0; i < _len; i++)
			{
				var overFormat:ElementFormat;
				var region:TextLineMirrorRegion = line.mirrorRegions[i];
				var bounds:Rectangle = region.bounds;

				var atom:int = line.getAtomIndexAtPoint(localX, localY);

				if(atom == -1)
				{
					//continue;
				}
				//var mouseBounds:Rectangle = line.getAtomBounds(atom);
				if(bounds.contains(localX,localY))
				{
					lineBox.graphics.clear();
					var ele:ContentElement = region.element;
					_overElement = ele;
					
					overFormat = ele.elementFormat.clone();
					//原来的色值
					var _color:int = overFormat.color;	
					//下划线的色值
					var _linkColor:int = ele.userData&&ele.userData["linkColor"]?ele.userData["linkColor"]:0xff0000;
					//滑入的字体色值
					overFormat.color = ele.userData&&ele.userData["hover"]?ele.userData["hover"]:color;
					ele.userData["hover"] = _color;
					ele.elementFormat = overFormat;

					var offsetY:Number = bounds.bottom;
					var offsetX:Number = 0;

					//回退到该mirror的第一个断行处
					while(region.previousRegion)
					{
						region = region.previousRegion;
						bounds = region.bounds;
						offsetY = bounds.bottom;
					}

					//回退该block第一行用于定位
					var _firstline:TextLine = region.textLine;

					while(_firstline.previousLine)
					{
						_firstline = _firstline.previousLine;
					}
					_points.x = _firstline.x;
					_points.y = _firstline.y;

					//绘制下划线
					do
					{
						//如果是第一行不缩进
						if(!region.textLine.previousLine)
						{
							offsetX = 0;
						}
						else
						{
							offsetX = _indent;
						}
						bounds = region.bounds;
						lineBox.graphics.beginFill(_linkColor, 1);
						lineBox.graphics.drawRect(bounds.left + offsetX, region.textLine.y, bounds.width, 1);
						lineBox.graphics.endFill();
						offsetY += bounds.height + leading;
						region = region.nextRegion;
					} while(region);
					break;
				}
			}
			
			var block:TextBlock = line.textBlock;
			var ge:GroupElement = block.content as GroupElement;
			if(_overElement)
			{
				removelineByTextBlock(block);
				//重建块
				createlineFromBlock(block, ge, _points);
			}
			block.releaseLineCreationData();
		}

		/**
		 * 删除block创建的所有行，不删除block
		 * @param	block
		 */
		private function removelineByTextBlock(block:TextBlock):void
		{
			var arr:Array = _linesHash[block];

			while(arr && arr.length > 0)
			{
				var line:TextLine = arr.shift();

				if(_lines.contains(line))
				{
					_lines.removeChild(line);
				}
			}
			delete _linesHash[block];
		}

		/**
		 * 为混排元素创建block
		 * @param	value
		 * @return
		 */
		protected function createBlockForElements(value:GroupElement):TextBlock
		{
			var _block:TextBlock = new TextBlock();
			_block.baselineZero = TextBaseline.DESCENT;
			return _block;
		}

		/**
		 * 向容器中添加一条显示元素
		 * @param	ele
		 */
		public function addElement(ele:GroupElement):void
		{
			//非激活状态缓存数据
			if(!_enabled)
			{
				if(!_cacheMap)
				{
					_cacheMap = new Vector.<GroupElement>();
				}
				_cacheMap.push(ele);
				return;
			}
			
			rollOutLine();
			
			_groups.push(ele);
			var _block:TextBlock = createBlockForElements(ele);
			_blockHash[ele] = _block;
			_block.content = ele;

			createlineFromBlock(_block, ele);
			//溢出检查
			valid();
		}

		/**
		 * 从block中创建行
		 * @param	block
		 * @param	ele
		 * @param	point	创建行的起始位置，默认为接着上一行创建
		 */
		private function createlineFromBlock(block:TextBlock, ele:GroupElement, point:Point = null):void
		{
			var lineMap:Array;

			if(!_linesHash[block])
			{
				_linesHash[block] = [];
			}
			lineMap = _linesHash[block];

			var line:TextLine = block.createTextLine(null, _textWidth);
			var _start:Number = point ? point.y : 0;
			var indent:Number = 0;
			while(line)
			{
				if(!point)
				{
					_ypos += line.height + _leading;
					line.y = _ypos;
				}
				else
				{
					if(line.previousLine)
					{
						_start += line.height + _leading;
					}
					line.y = _start;
				}

				line.x = indent;

				_lines.addChild(line);
				lineMap.push(line);
				//如果定义了例外缩进用例外的
				var _elementIndent:int = elementIndent(ele);
				indent = _elementIndent == 0 ? _indent : _elementIndent;
				line = block.createTextLine(line, _textWidth - indent);
			}
			block.releaseLineCreationData();
		}

		/**
		 * 从groupelement的userdata中获取断行缩进
		 * @param	ele
		 * @return
		 */
		private function elementIndent(ele:GroupElement):int
		{
			if(ele.userData && ele.userData["indent"])
			{
				return ele.userData["indent"];
			}
			return 0;
		}

		/**
		 * 矫正容器行数（删除超出的行数）
		 */
		private function valid():void
		{
			var reduce:Number = 0;
			var line:TextLine;
			var index:uint = 0;

			var max:uint = _locked ? _max * 2 : _max;

			//删除多余行
			while(_lines.numChildren > max && _lines.numChildren > 0)
			{
				line = _lines.getChildAt(0) as TextLine;

				try
				{
					_lines.removeChild(line);
				}
				catch(e:Error)
				{
					trace("GraphicText:", e.message);
				}

				if(line)
				{
					var block:TextBlock = line.textBlock;
					var lineArr:Array = _linesHash[block];
					lineArr.splice(lineArr.indexOf(line), 1);

					if(lineArr.length == 0)
					{
						delete _linesHash[block];
						delete _blockHash[block.content];
						block.releaseLineCreationData();
						block = null;
					}
				}
			}

			//排列剩余行
			if(_lines.numChildren > 0 && line)
			{
				line = _lines.getChildAt(0) as TextLine;
				reduce = line.getBounds(_lines).top - _leading;
				_ypos -= reduce;

				for(index = 0; index < _lines.numChildren; index++)
				{
					line = _lines.getChildAt(index) as TextLine;
					line.y -= reduce;
				}
			}
			line = null;
			System.pauseForGCIfCollectionImminent(0);
		}

		public function resize():void
		{
			reset();
			if(_groups)
			{
				var local:Vector.<GroupElement> = _groups.concat();
				
				for each(var i:GroupElement in local)
				{
					var block:TextBlock = _blockHash[i];
					block.content = i;
					_linesHash[block] = [];
					createlineFromBlock(block, i);
				}
				//溢出检查
				valid();
			}
		}

		/**
		 * 清空显示行
		 */
		private function reset():void
		{
			_ypos = 0;
			_lines.removeChildren();
			System.pauseForGCIfCollectionImminent(0);
		}

		/**
		 * 设置统一断行缩进
		 */
		public function set warpIndent(value:int):void
		{
			_indent = value;
			resize();
		}

		/**
		 * 限制断行宽度，默认为2000px
		 */
		public function set textWidth(value:Number):void
		{
			_textWidth = value;
			resize();
		}

		public function get textWidth():Number
		{
			return _textWidth;
		}

		public function set maxLines(value:uint):void
		{
			_max = value;
			resize();
		}

		public function get maxLines():uint
		{
			return _max;
		}

		public function set locked(bool:Boolean):void
		{
			_locked = bool;
		}

		public function get locked():Boolean
		{
			return _locked;
		}

		public function set leading(value:int):void
		{
			_leading = value;
			resize();
		}

		public function get leading():int
		{
			return _leading;
		}

		public function set enabled(bool:Boolean):void
		{
			_enabled = bool;

			if(bool)
			{
				//激活以后清除缓存数据
				while(_cacheMap && _cacheMap.length > 0)
				{
					addElement(_cacheMap.shift());
				}
			}
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

		public function clear():void
		{
			reset();
			if(_groups)_groups.length = 0;
			if(_cacheMap)_cacheMap.length = 0;

			for(var b:* in _linesHash)
			{
				delete _linesHash[b];
			}

			for(var e:* in _blockHash)
			{
				delete _blockHash[e];
			}
			_overElement = null;
		}

		/**
		 * 执行后不能再使用addElement添加
		 */
		public function dispose():void
		{
			clear();
			_indent = 0;
			_groups = null;
			_event.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
			_event.removeEventListener(MouseEvent.MOUSE_OUT, overHandler);
			_event.removeEventListener(MouseEvent.CLICK, onClick);
			_event = null;
		}
	}

}