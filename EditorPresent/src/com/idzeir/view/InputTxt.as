package com.idzeir.view 
{
	import com.idzeir.utils.Utils;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author idzeir
	 */
	public class InputTxt extends TextField 
	{
		
		public function InputTxt() 
		{
			super();
			this.type = "input";
			
			var tf:TextFormat = new TextFormat(Utils.FONT_NAME);
			tf.leftMargin = 2;
			
			this.defaultTextFormat = tf;
			this.height = 20;
			this.multiline = false;
			this.maxChars = 20;
			this.border = true;
			this.borderColor = 0xffffff;
			this.background = true;
			this.backgroundColor = 0xC0C0C0;
			
			this.textColor = 0x0000ff;
		}
		
	}

}