package com.idzeir.flashviewer.bussies.enum
{	
	
	/**
	 * 业务枚举
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Jun 21, 2014 5:38:56 PM
	 *
	 **/
	
	public class Enum
	{
		/**
		 * 表格显示资源缩略事件
		 * 参数为索要显示文件夹内的文件数组 
		 */		
		static public const SHOW_FILES:String = "showFiles";
		/**
		 * 预览swf文件
		 * 参数为文件地址 
		 */		
		static public const PREVIEW_FILE:String = "previewFile";
		/**
		 * 错误提示
		 * 参数为错误信息 可以为富文本串 
		 */		
		public static const ERROR_INFO:String = "errorInfo";
		/**
		 * 点击空文件夹清除当前的显示卡片
		 */		
		public static const CLEAR_CURRENT_FILE_CARDS:String = "clearCurrentFileCards";
		/**
		 * 后台生成缩略图
		 * 参数为根目录file对象 
		 */		
		public static const PHOTO:String = "photo";
		/**
		 * 后台生成缩略图派发
		 * 参数为缩略图地址 
		 */		
		public static const CREATE_PHOTO_COMPLETE:String = "createPhotoComplete";
		/**
		 * 未找到资源文件夹
		 * 参数为信息内容 
		 */		
		public static const NO_FOLDER_EXIST:String = "noFolderExist";
		/**
		 * alert 弹窗全部弹完调用 
		 */		
		public static const ERROR_ALL_CLEAR:String = "errorAllClear";
		/**
		 * 注册成功初始化界面 
		 */		
		public static const SUCCESS_REGISTER:String = "successRegister";
		/**
		 * 打开根目录 
		 */		
		public static const OPEN_ROOT:String = "openRoot";
		/**
		 * 进入主界面 
		 */		
		public static const READY_INIT:String = "readyInit";
		/**
		 * 生产key
		 */		
		public static const CREATE_REQ:String = "createReq";
	}
}