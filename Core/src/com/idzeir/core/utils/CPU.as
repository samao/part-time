package com.idzeir.core.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	/**
	 * CPU 序列号获取工具，在profile为extendedDesktop才支持查询 
	 * @author idzeir
	 * 
	 */	
	public class CPU
	{
		/**
		 * 获取系统CPU序列号 (限于windows系统)
		 * @param ok 成功回调函数 参数为序列号字符串
		 * @param fail 失败回调
		 * 
		 */		
		static public function getCPU(ok:Function,fail:Function = null):void
		{
			if (!NativeProcess.isSupported)
			{
				if(fail!=null)
				{
					fail.apply();
				}
			}
			var MOTHERBOARD_SERIALNUMBER_COMMAND:String = "wmic baseboard get serialnumber";// get product, manufacturer, serialnumber";
			
			var file:File = new File("C:\\Windows\\System32\\cmd.exe");
			
			var args:Vector.<String> = new Vector.<String>();
			args.push("/c");
			args.push(MOTHERBOARD_SERIALNUMBER_COMMAND);
			
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;         
			nativeProcessStartupInfo.arguments = args;
			
			var nativeProcess:NativeProcess = new NativeProcess(); 
			
			var outputDataEventHandler:Function =  function(event:ProgressEvent):void 
			{ 
				var output:String = nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable);
				clear();
				
				var id:String = (output.split("\r\n")[1].replace(/(\r| )/ig,""));
				if(ok!=null)
				{
					ok.apply(null,[id]);
				}
			}
			
			var outputErrorEventHandler:Function =  function(event:ProgressEvent):void
			{
				clear();
				if(fail!=null)
				{
					fail.apply();
				}
			};
			
			var clear:Function = function clear():void
			{
				nativeProcess.exit();
				nativeProcess.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputDataEventHandler);
				nativeProcess.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, outputErrorEventHandler);
			}
			nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputDataEventHandler);
			nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, outputErrorEventHandler);
			nativeProcess.start(nativeProcessStartupInfo);
		}	
	}
}