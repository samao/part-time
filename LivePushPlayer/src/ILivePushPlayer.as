package
{

	/**
	 * flash提供接口
	 * @author: idzeir
	 * @E-mail: qiyanlong@wozine.com
	 * @time: Aug 5, 2014 7:44:17 PM
	 *
	 **/

	public interface ILivePushPlayer
	{
		/**
		 * 停止播放流或者停止推流
		 */
		function stopStream():void
		/**
		 * 推流接口
		 * @param _rtmp 服务器地址
		 * @param id 流id
		 * @param cam 摄像头名字
		 * @param mic 麦的名字
		 */
		function publish(_rtmp:String, id:String, cam:String = null, mic:String = null):void
		/**
		 * 播放流接口
		 * @param _rtmp 服务器地址
		 * @param id 流id
		 */
		function playStream(_rtmp:String, id:String):void

		/**
		 * 在不调用play接口分别指定rtmp和流id的情况下调用此接口播放流
		 * 推流时不需要调用，调用play接口时候flash自动调用
		 */
		function playLive():void
		/**
		 * 设置播放器背景图
		 * @param value 背景图片连接
		 */
		function setBackground(value:String):void
		/**
		 * 单独设置rtmp播放的流id
		 * @param value 流名称即流id
		 */
		function streamName(value:String):void
		/**
		 * 设置rtmp服务器地址
		 * @param url 服务器地址
		 */
		function setRtmp(url:String):void

		/**
		 * 播放流时候设置播放的音量0-1
		 */
		function setVolume(value:Number):void
	}
}

/**
 * flash调用的接口
 * 1、playerReady:接口初始化通知。收到这个之后所有接口才可以调用了，无参数
 * 2、onRtmpBreak：流播放异常断开调用，收到这个消息可以调用playLive重播，可选字符串参数
 */