package com.ceflash.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.ByteArray;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public class Tools	{
		public static const millisecondsPerMinute:int = 1000 * 60;
		public static const millisecondsPerHour:int = 1000 * 60 * 60;
		public static const millisecondsPerDay:int = 1000 * 60 * 60 * 24;
		
		public static function twoDigits(x:Number):Number {
				return (Math.round(x*100)/100);
		}
		public static function getSpace(x:Number):String{
			var _size:String = x.toString();
			if (x>1024*1024*1024) {
				_size = twoDigits(x/1024/1024/1024)+" GB";
			} else if (x>1024*1024) {
				_size = twoDigits(x/1024/1024)+" MB";
			} else if (x>1024) {
				_size = twoDigits(x/1024)+" KB";
			} else if (x>=0) {
				_size = twoDigits(x)+" byte";
			} else {
				_size = "Directory";
			}
			return _size
		}
		public static function compareString(s1:String,s2:String):Boolean
		{
			return (s1==s2);
		}
		public static function getDateStr(d:Date,patten:String="-"):String
		{
			return d.fullYear+patten+(d.month+1)+patten+d.date;
		}
		public static function getDateTimeStr(specialDate:Date,_type:int=1):String
		{
			var _nowDate:*=new Date();
			if(specialDate)_nowDate = specialDate;
			var _Month:* = _nowDate.getMonth() + 1;
			var _Date:* = _nowDate.getDate();
			var _Hours:* = _nowDate.getHours();
			var _Minutes:* = _nowDate.getMinutes();
			var _Seconds:* = _nowDate.getSeconds();
			var _Milliseconds:* = _nowDate.getMilliseconds()
			var _nowTime:*=""
			if(_Month<10){
				_Month="0"+_Month;
			}
			if(_Date<10){
				_Date="0"+_Date;
			}
			if(_Hours<10){
				_Hours="0"+_Hours;
			}
			if(_Minutes<10){
				_Minutes="0"+_Minutes;
			}
			if(_Seconds<10){
				_Seconds="0"+_Seconds;
			}
			if(_Milliseconds<10){
				_Milliseconds="00"+_Milliseconds
			}else if(_Milliseconds<100){
				_Milliseconds="0"+_Milliseconds
			}
			if(_type==1){
				_nowTime=_Hours+":00"+" "+_Month+"/"+_Date+"/"+_nowDate.fullYear;
			}else if(_type==2){
				_nowTime=_nowDate.fullYear+"-"+_Month+"-"+_Date+" "+_Hours+":"+_Minutes+":"+_Seconds
			}else if(_type==3){
				_nowTime=_nowDate.fullYear+""+_Month+""+_Date+""+_Hours+""+_Minutes+""+_Seconds+""+_Milliseconds;
			}
			return _nowTime;
		}
		public static function getDateRange(d1:Date,d2:Date):String
		{
			var re:String = "";
			var d1str:String = getDateStr(d1,"/");
			var d2str:String = getDateStr(d2,"/");
			var m1str:String = String(d1.minutes);
			var m2str:String = String(d2.minutes);
			while(m1str.length<2){
				m1str = "0"+m1str;
			}
			while(m2str.length<2){
				m2str = "0"+m2str;
			}
			if(d1str==d2str){
				re = d1.hours+":"+m1str+" - "+d2.hours+":"+m2str;
			}else{
				re = d1str+" "+d1.hours+":"+m1str+" - "+d2str+" "+d2.hours+":"+m2str;
			}
			return re;
		}
		public static function getDateFromStr(str:String,patten:String="-"):Date
		{
			var arr:Array = str.split(patten);
			return new Date(arr[0],arr[1]-1,arr[2]);//d.fullYear+"-"+(d.month+1)+"-"+d.date;
		}
		public static function getDateFromFullStr(str:String):Date
		{
			var arr:Array = str.split(" ");
			if(arr.length!=2)return null;
			var arr1:Array = arr[0].split("-");
			var arr2:Array = arr[1].split(":");
			return new Date(arr1[0],arr1[1]-1,arr1[2],arr2[0],arr2[1],arr2[2]);
		}
		public static function getPreviousDay(d:Date):Date
		{
			return new Date(d.getTime()-millisecondsPerDay);
		}
		public static function getNextDay(d:Date):Date
		{
			return new Date(d.getTime()+millisecondsPerDay);
		}
		public static function formatToTime(s:Number,type:String):String
		{
			var hour:Number=Math.floor(s/3600);
			var minute:Number=Math.floor((s%3600)/60);
			var second:Number=Math.floor(s%60);
			//var ms:Number=s*1000%1000;
			var hourStr:String="";
			var minuteStr:String="";
			var secondStr:String="";
			//var msStr:String=""
			if(hour<10){
				hourStr="0"+hour;
			}else{
				hourStr=hour.toString();
			}
			if(minute<10){
				minuteStr="0"+minute;
			}else{
				minuteStr=minute.toString();
			}
			if(second<10){
				secondStr="0"+second;
			}else{
				secondStr=second.toString();
			}
			var re:String = "";
			switch(type){
				case "hh:mm":
					re = hourStr+":"+minuteStr;
					break;
				case "hh:mm:ss":
					re = hourStr+":"+minuteStr+":"+secondStr;
					break;
				default:
					re = hourStr+":"+minuteStr+":"+secondStr;
			}
			
			return re;
		}
		public static function CopyObject(source:Object):*
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(source);
			bytes.position = 0;
			return(bytes.readObject());
		}
		public static function getBaseURL(__url:String):String
		{
			var swfURL:String = __url;
			var temp:String = swfURL.split("?")[0];//有参数的都在问号后面，取前面的
			var arr:Array = temp.split("/");//被“/”分割成N段，取最后一段
			arr = arr[(arr.length-1)].split("\\");
			arr = arr[(arr.length-1)].split(":");//最后一段是得到的带后缀名的文件名
			//arr = arr[(arr.length-1)].split(".");//得到不带后缀的文件名
			temp = arr[(arr.length-1)];
			var baseURL:String = swfURL.substring(0,swfURL.indexOf(temp));
			return baseURL;
		}
		public static function getFileInfo(fileName:String):Array
		{
			var endStr:*;
			endStr = fileName.split("?");
			endStr = endStr[0].split("/");
			endStr = endStr[(endStr.length - 1)].split("\\");
			endStr = endStr[(endStr.length - 1)].split(":");
			endStr = endStr[(endStr.length-1)].split(".");
			endStr = endStr[(endStr.length - 1)];
			var baseURL:String = fileName.substring(0,fileName.lastIndexOf(endStr)-1);
			var ext:String = fileName.substring(fileName.lastIndexOf(endStr));
			endStr = [baseURL,ext];
			return endStr;
		}
		public static function getFileName(f:String):String
		{
			var swfURL:String = f;
			var temp:String = swfURL.split("?")[0];//有参数的都在问号后面，取前面的
			var arr:Array = temp.split("/");//被“/”分割成N段，取最后一段
			arr = arr[(arr.length-1)].split("\\");
			arr = arr[(arr.length-1)].split(":");//最后一段是得到的带后缀名的文件名
			arr = arr[(arr.length-1)].split(".");//得到不带后缀的文件名
			return arr[0];
		}
		
		//二进制转十进制用bin2dec，十进制转任意n用.toString(n),如转二进制用.toString(2),.toString(16)
		public static function bin2dec(bin:String):int
		{
			var dec:Number = 0;
			var n:Number = bin.length;
			for(var i:Number = 0; i < n; ++i){
				dec += int(bin.charAt(i))*(Math.pow(2, n-i-1))
			}
			return dec
		}
		
		public static function radians(x:Number):Number
		{
			return Math.PI*x/180;
		}
		public static function degrees(x:Number):Number
		{
			return 180*x/Math.PI;
		}
		public static function checkHave(a:Object,b:Array,prop:String):int
		{
			var len:int = b.length;
			for(var i:int=0;i<len;i++){
				if(a.hasOwnProperty(prop)&&b[i].hasOwnProperty(prop)&&a[prop]==b[i][prop]){
					return i;
				}
			}
			return -1;
		}
		public static function subTract(color1:uint, color2:uint):uint
		{
			var a:Array = toARGB(color1);
			var b:Array = toARGB(color2);
			var mr:uint = Math.max(Math.max(b[0] - (256 - a[0]), a[0] - (256 - b[0])), 0);
			var mg:uint = Math.max(Math.max(b[1] - (256 - a[1]), a[1] - (256 - b[1])), 0);
			var mb:uint = Math.max(Math.max(b[2] - (256 - a[2]), a[2] - (256 - b[2])), 0);
			return toDec(mr, mg, mb);
		}
	/**

        * RGB颜色加法混合. 示例参考"GB颜色互补色减法混合"中的例子

        *

        * @param      color1

       * @param      color2

        * @return

        */

       public static function sum(color1:uint, color2:uint):uint

       {

                var a:Array = toARGB(color1);

                var b:Array = toARGB(color2);

                var mr:uint = Math.min(a[0] + b[0], 255);

                var mg:uint = Math.min(a[1] + b[1], 255);

                var mb:uint = Math.min(a[2] + b[2], 255);

                return toDec(mr, mg, mb);

       }

      

       /**

        * RGB颜色减法混合.示例参考"GB颜色互补色减法混合"中的例子

        *

        * @param      color1

        * @param      color2

        * @return

        */

       public static function sub(color1:uint , color2:uint):uint

       {

                var a:Array = toARGB(color1);

                var b:Array = toARGB(color2);

                var mr:uint = Math.max(a[0] - b[0], 0);

                var mg:uint = Math.max(a[1] - b[1], 0);

                var mb:uint = Math.max(a[2] - b[2], 0);

                return toDec(mr, mg, mb);

       }

      

      

       /**

        * 取两个颜色的暗调.示例参考"GB颜色互补色减法混合"中的例子

        *

        * @param      color1

        * @param      color2

        * @return

        */

       public static function min(color1:uint, color2:uint):uint

       {

                var a:Array = toARGB(color1);

                var b:Array = toARGB(color2);

                var mr:uint = Math.min(a[0], b[0]);

                var mg:uint = Math.min(a[1], b[1]);

                var mb:uint = Math.min(a[2], b[2]);

                return toDec(mr, mg, mb);

       }

      

       /**

        * 取两个颜色的明调.示例参考"GB颜色互补色减法混合"中的例子

        *

        * @param      color1

        * @param      color2

        * @return

        */

       public static function max(color1:uint, color2:uint):uint

       {

                var a:Array = toARGB(color1);

                var b:Array = toARGB(color2);

                var mr:uint = Math.max(a[0], b[0]);

                var mg:uint = Math.max(a[1], b[1]);

                var mb:uint = Math.max(a[2], b[2]);

                return toDec(mr, mg, mb);

       }

      

      

       /**

        * 拆分ARGB颜色,返回包含R，G，B，A通道值的数组

        *

        * @param      color  要分解的ARGB颜色数值

        * @return

        *

        * <listing>

        * import lib.base.maths.CColorMath;

        * var color:uint = 0xFF80FFFF;

        * trace(CColorMath.toARGB(color)); //128,255,255,255

        * </listing>

        */

      public static function toARGB(color:uint):Array

       {

                var a:uint = color >> 24 & 0xFF;

                var r:uint = color >> 16 & 0xFF;

                var g:uint = color >> 8 & 0xFF;

                var b:uint = color & 0xFF;

                return [r, g, b, a];

       }

      

      

       /**

        * 合并A，R，G，B颜色通道

        *

       * @param      r  红色通道

        * @param      g  绿色通道

        * @param      b  蓝色通道

        * @param      a  透明度

        * @return

        */

       public static function toDec(r:uint, g:uint, b:uint, a:uint = 255):uint

       {

                var sa:uint = a << 24;

                var sr:uint = r << 16;

                var sg:uint = g << 8;

                return sa | sr | sg | b;

       }
 }
}