/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.acfun.tv		
 * Created:	May 30, 2015 2:53:45 PM			
 * ===================================
 */

package com.idzeir.core.utils
{
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	
	public class HardwareUtil
	{
		public static function get hardwareAddress():String
		{
			if(NetworkInfo.isSupported)
			{
				var map:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
				for each(var net:NetworkInterface in map)
				{
					if(net.hardwareAddress!=null&&net.hardwareAddress!=""&&net.active)
					{
						return net.hardwareAddress;
					}
				}
			}
			return null;
		}
	}
}