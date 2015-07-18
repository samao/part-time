package com.idzeir.buissnes
{
	/**
	 * 枚举数据
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 2, 2014||10:38:39 AM
	 */
	public class Enum
	{
		/**
		 * 17173网址
		 */
		public static const WEB_URL:String = "http://v.17173.com/show/";
		/**
		 * wohai dizhi 
		 */		
		public static const WOHAI_URL:String = "http://www.wohai.com/";

		/**
		 * 大厅数据
		 * post 请求 无参数
		 * 返回 全部房间信息
		 */
		public static const GET_ALL_ANCHOR:String = WEB_URL + "inter_liveList.action";
		
		public static const GET_WOHAI_ANCHOR:String = WOHAI_URL+"live/live!allanchor.action";
		/**
		 * rtmp流数据
		 * post 请求 传入用户id
		 * 返回流地址和流名称
		 */
		public static const GET_STREAM_ADDRESS:String = WOHAI_URL + "live/video!streamadr.action";
		/**
		 * 获取 用户id
		 * post请求 传入数据roomid
		 * 返回用户id
		 */
		public static const GET_ANCHOR_BY_ROOM_ID:String = WEB_URL + "pd_hole.action";
		
		public static const GET_WOHAI_ANCHOR_BY_ROOM_ID:String = WOHAI_URL + "live/live!getanchorbyroomid.action";
		
		public static const GSLB_URL:String = "http://gslb.v.17173.com/show/live";
		
		/**
		 * 提交随机key让服务器生成游客用户 
		 * visitorsessionid=1400000000&roomid=10356
		 */		
		public static const SET_GUEST_KEY:String = WOHAI_URL + "chat/chat!visitorjoinbypoll.action";
		
		/**
		 * 用随机key查询用户信息
		 * visitorsessionid=1400000000
		 */		
		public static const GET_GUEST_INFO:String = WOHAI_URL + "chat/chat!getvisitorname.action";
		/**
		 * 轮询聊天内容
		 * datenocache[随机数]&username=yk_010286
		 */		
		public static const GET_CHAT_MSG:String = WOHAI_URL + "chat/chat!getmsgbypoll.action";
		/**
		 * 心跳 
		 * ?datenocache621&visitorsessionid = 1；
		 */		
		public static const SEND_HEART:String = WOHAI_URL + "chat/chat!heartbeat.action";
		
		/**
		 * 游客加入聊天
		 * visitorsessionid="+visitorsessionid+'&roomid="
		 */		
		public static const GUEST_JOIN_IN:String = WOHAI_URL + "chat/chat!visitorjoinbypoll.action";
		
		/**
		 * 进入房间 
		 */		
		public static const ACTION_INTO_ROOM:String = "actionIntoRoom";
		/**
		 * 获取大厅数据 
		 */		
		public static const ACTION_GET_LOBBY:String = "actionGetLobby";
		/**
		 * 获取流数据 
		 */		
		public static const ACTION_GET_RTMP:String = "actionGetRtmp";
		/**
		 * 播放流 
		 */		
		public static const ACTION_PlAY_STREAM:String = "actionPlayStream";
		/**
		 * 获取房间信息 
		 */		
		public static const ACTION_ROOM_INFO:String = "actionRoomInfo";
		/**
		 * tip提示 
		 */		
		public static const ACTION_SHOW_TIPS:String = "actionShowTips";
		/**
		 * 提交用户key 
		 */		
		public static const ACTION_SUBMIT_SESSION:String = "actionSubmitSession";
		/**
		 * 根据key查询用户 
		 */		
		public static const ACTION_GET_USER:String = "actionGetUser";
	}
}