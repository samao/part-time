package com.idzeir.core.utils
{
	import flash.errors.IOError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SWFPaser
	{
		/**
		 * 控制码列表
		 */
		static private var _codes:Array = 
			[		
				{ctrlCode: "50", position: [[0, 10], [5, 10], 5]},
				{ctrlCode: "58", position: [[1, 40], [6, 10], 6]},
				{ctrlCode: "60", position: [[1, 10], [7, 10], 6]},
				{ctrlCode: "68", position: [[2, 40], [8, 10], 7]},
				{ctrlCode: "70", position: [[2, 10], [9, 10], 7]},
				{ctrlCode: "78", position: [[3, 40], [10, 10], 8]},
				{ctrlCode: "80", position: [[3, 10], [11, 10], 8]},
				{ctrlCode: "88", position: [[2, 40], [12, 10], 9]}
			]
		/**
		 * 标识CWS、FWS
		 */
		static private var _type:String;
		/**
		 * swf版本
		 */
		static private var _version:uint;
		/**
		 * 文件大小
		 */
		static private var _size:uint;
		/**
		 * 舞台宽
		 */
		static private var _width:uint; 
		/**
		 * 场景高
		 */
		static private var _height:uint;
		/**
		 * 帧频
		 */
		static private var _fps:uint; 
		/**
		 * 主时间轴帧数
		 */
		static private var _frames:uint; 

		public function SWFPaser()
		{
			throw new Error("工具类不许new");			
		}

		static public function parse(bytes:ByteArray):Object
		{
			var binary:ByteArray = new ByteArray;
			binary.endian = Endian.LITTLE_ENDIAN;
			
			//取前8个字节,包括了是否是swf,版本号,文件大小;
			bytes.readBytes(binary, 0, 8);
			
			//前3个字节是SWF文件头标志，FWS表示未压缩，CWS表示压缩的SWF文件
			_type = binary.readUTFBytes(3); 
			//第4个字节为版本号
			_version = binary[3]; 
			//文件大小按照8765字节的顺序排列的16进制
			_size = binary[7] << 24 | binary[6] << 16 | binary[5] << 8 | binary[4]; 
			
			//移到第9个字节位置，从这里开始就是swf 的控制码区和宽高数据区,宽高最多占用9个字节
			binary.position = 8; 
			var mainData:ByteArray = new ByteArray;
			bytes.readBytes(mainData);

			if (_type == "CWS")
			{
				//未压缩的swf标识是FWS，压缩过的swf标识是CWS
				//从第9个字节起用解压缩;
				mainData.uncompress();								
			}
			else if ((_type != "FWS"))
			{
				//不是cws,也不是fws,表示不是swf文件，抛出错误！
				throw new IOError("不是swf文件");
			} 
			
			binary.writeBytes(mainData, 0, 13);
			
			//再写13个字节，这里包括了swf的帧速/帧数;
			//当前第8个字节位为控制码
			var ctrlCode:String = binary[8].toString(16);
			
			var w_h_plist:Array = getPoints(ctrlCode);
			var len:Number = w_h_plist[2];
			
			//trace("宽高占用"+len+"个字节");
			var s:String = ""; //存储宽高数据的相关字节码
			for (var i:int = 0; i < len; i++)
			{
				var _temp:* = binary[i + 9].toString(16);
				if (_temp.length == 1)
				{
					_temp = "0" + _temp;
				}
				s += _temp;

			}
			//相应取值得到宽高
			_width = new Number(("0x" + s.substr(w_h_plist[0][0], 4))) / w_h_plist[0][1];
			_height = new Number(("0x" + s.substr(w_h_plist[1][0], 4))) / w_h_plist[1][1]; 
			
			var pos:Number = 8 + len;
			//宽高数据区完跳一字节位置就是fps值
			_fps = binary[pos += 2]; 
			
			//帧数占两个字节，由低位到高位组成,是不是说时间轴的最大帧数就为65535
			_frames = binary[pos + 2] << 8 | binary[pos + 1]; 
			
			return { width:_width, height:_height, size:_size, fps:_fps, totalFrames:_frames, type:_type, version:_version };
		}

		static private function getPoints(str:String):Array
		{
			for (var i:* in _codes)
			{
				if (_codes[i].ctrlCode == str)
				{
					break;
				}
			}
			return _codes[i].position;
		}
	}
}