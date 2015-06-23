package com.idzeir.core.view
{
	import com.idzeir.core.utils.Utils;
	
	import flash.utils.getQualifiedClassName;
	

	public class Logger
	{
		static public var _ilog:ILoger;
	
		static public function out(...arg:*):void
		{
			if(arg.length>0)
			{
				var params:Array = [];
				
				var first:* = arg.shift();
				if(!Utils.isSimpleType(first))
				{
					var type:String = getQualifiedClassName(first);
					if(type.indexOf("::")!=-1)
					{
						var s:String = type.split("::")[1];
						params.push("<font color='#ff0000'> <b>"+s+"</b> </font>");
					}else{
						params.push("<font color='#ff0000'> <b>"+type+"</b> </font>");
					}
				}else{
					params.push(first)
				}
				arg.forEach(function(e:*,index:int,arr:Array):void
				{
					params.push(e);
				});
			}
			_ilog.log(params);
		}
		
		static public function unTimeLog(...arg:*):void
		{
			if(arg.length>0)
			{
				var params:Array = [];
				
				var first:* = arg.shift();
				if(!Utils.isSimpleType(first))
				{
					var type:String = getQualifiedClassName(first);
					if(type.indexOf("::")!=-1)
					{
						var s:String = type.split("::")[1];
						params.push("<font color='#00ff00'> <b>"+s+"</b> </font>");
					}else{
						params.push("<font color='#00ff00'> <b>"+type+"</b> </font>");
					}
				}else{
					params.push(first)
				}
				arg.forEach(function(e:*,index:int,arr:Array):void
				{
					params.push(e);
				});
			}
			_ilog.unTimeLog(params);
		}
	}
}