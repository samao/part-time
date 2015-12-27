/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	May 30, 2015 12:29:32 PM			
 * ===================================
 */

package com.idzeir.flashviewer.module.register
{
	import com.hurlant.util.Base64;
	import com.idzeir.core.bussies.Delegate;
	import com.idzeir.core.events.ViewEvent;
	import com.idzeir.core.utils.HardwareUtil;
	import com.idzeir.core.view.Logger;
	import com.idzeir.flashviewer.bussies.enum.Enum;
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	
	public class RegisterModuleDelegate extends Delegate
	{
		private var conn:SQLConnection = new SQLConnection();
		
		/**
		 * 数据库文件名
		 */		
		private const DB_URL:String = "user.db";
		/**
		 * 请求文件文件名 
		 */		
		private const KEY:String = "key.req";
		/**
		 * 数据库文件 
		 */		
		private var dbFile:File;

		private var sqlStatement:SQLStatement;
		/**
		 * 文件间隔 
		 */		
		private const _FORMAT_:String = "#register$";
		
		public function RegisterModuleDelegate(_warp:String="RegisterModule.swf")
		{
			super(_warp);
			
			checkAuthor();
		}
		
		private function checkAuthor():void
		{
			var folder:File = File.applicationDirectory;
			dbFile = folder.resolvePath("data/"+DB_URL);
			conn.addEventListener(SQLEvent.OPEN,openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR,errorHandler);
			conn.openAsync(dbFile);
			
			sqlStatement = new SQLStatement();
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,onSQLError);
		}
		
		override public function addViewListener():void
		{
			if(_view)
			{
				_view.addEventListener("create",function(e:ViewEvent):void
				{
					Logger.out("使用的邮箱是：",e.info,HardwareUtil.hardwareAddress);
					_view.apply("waitCreateFile","发送安装目录下的 <font color='#ff0000'>"+KEY+"</font> 发送给作者进行授权！");
					var file:File = new File(File.applicationDirectory.nativePath+"/"+KEY);
					var fs:FileStream = new FileStream();
					fs.open(file,FileMode.WRITE);
					fs.writeUTFBytes(Base64.encode(HardwareUtil.hardwareAddress+_FORMAT_+e.info));
					fs.close();
					
					_e.send(Enum.CREATE_REQ);
				});
			}
		}
		
		/**
		 * 不存在数据库文件
		 */		
		protected function errorHandler(event:Event):void
		{
			this.excute(openRegister);
		}
		
		protected function openHandler(event:SQLEvent):void
		{
			//生成库
			var sql:String = "CREATE TABLE IF NOT EXISTS copyright (" +
				" hardware TEXT," +
				" mail TEXT," +
				" date NUMERIC)";
			//生成数据
			sql = "INSERT INTO copyright" +
				" (hardware,mail,date)" +
				" VALUES ('','','"+new Date().time+"')";
			//读取数据
			sql = "SELECT hardware,mail,date FROM copyright";
			
			sqlStatement.sqlConnection = conn;
			sqlStatement.addEventListener(SQLEvent.RESULT,function():void
			{
				sqlStatement.removeEventListener(SQLEvent.RESULT,arguments.callee);
				Logger.out("注册验证代码执行结束");
				var result:SQLResult = sqlStatement.getResult(); 
				var numResults:int = result.data.length; 
				for (var i:int = 0; i < numResults; i++) 
				{ 
					var row:Object = result.data[i]; 
					//trace(JSON.stringify(row));
					check(row["hardware"]);
					break;
				} 
			});
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		/**
		 * sql语句执行错误
		 */		
		private function onSQLError(e:SQLErrorEvent):void
		{
			Logger.out("注册验证代码错误");
		}
		
		/**
		 * 验证注册
		 */		
		private function check(key:String):void
		{
			const SECRET_KEY:String = "iDzEirLonGLoNg";
			if(Base64.encode(HardwareUtil.hardwareAddress+SECRET_KEY) == key)
			{
				//已经注册
				this.excute(gotoWork);
			}else{
				var regFile:File = new File(File.applicationDirectory.nativePath+"/key.res");
				//是否正在注册，存在注册反馈文件
				if(regFile.exists)
				{
					//开始分析注册文件
					Logger.out("发现注册文件，写入信息");
					regFile.addEventListener(Event.COMPLETE,function():void
					{
						regFile.removeEventListener(Event.COMPLETE,arguments.callee);
						write(regFile.data);
						regFile.deleteFile();
					});
					regFile.load();
				}else{
					Logger.out("验证信息不匹配，请重新注册");
					excute(openRegister);
				}
			}
		}
		
		/**
		 * 删除注册界面，进入软件
		 */		
		private function gotoWork(value:* = null):void
		{
			_view.apply("removeFromParent");
			_e.send(Enum.SUCCESS_REGISTER);
		}
		
		/**
		 * 将注册返回文件的内容写入数据库
		 */		
		private function write(value:ByteArray):void
		{
			var data:String = Base64.decode(value.readUTFBytes(value.bytesAvailable));
			var arr:Array = data.split(_FORMAT_);
			var hardware:String = arr[0];
			var mail:String = arr[1];
			var time:Number = arr[2];
			
			var sql:String = "UPDATE copyright SET hardware = '"+Base64.encode(hardware)+"', mail = '"+mail+"',date = "+time;
			sqlStatement.sqlConnection = conn;
			sqlStatement.addEventListener(SQLEvent.RESULT,function():void
			{
				sqlStatement.removeEventListener(SQLEvent.RESULT,arguments.callee);
				//更新成功进入软件
				excute(gotoWork);
			});
			sqlStatement.text = sql;
			sqlStatement.execute();
		}
		
		private function openRegister(value:* = null):void
		{
			this._view.apply("openRegister");
		}
	}
}