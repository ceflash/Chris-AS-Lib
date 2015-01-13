package com.ceflash.api.file
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FileUtil
	{
		private static var loadedFileNum:int=0;
		private static var totalFileNum:int=0;
		public static function getFiles (directory:File,ext:String="*",searchDepth:int=0):Array
		{
			var fs:Array=new Array()
			if(!directory.exists){
				return fs
			}
//			trace(directory.name);
			var items:Array=directory.getDirectoryListing();
			for(var i:int=0;i<items.length;i++){
				var f:File=items[i];
				if(f.isDirectory){
					if(searchDepth){
						fs = fs.concat(getFiles(f,ext,searchDepth-1));
					}
				}else{
					if(ext=="*"&&f.name.substr(0,1)!='.'||f.extension&&(ext.toLowerCase().indexOf(f.extension.toLowerCase())!=-1)){
						fs.push(f);
					}
				}
			}
			return fs;
		}
		public static function getDirectories (directory:File):Array
		{
			var ds:Array=new Array()
			if(!directory){
				return ds
			}
			var items:Array=[]
			if(directory.exists){
				items=directory.getDirectoryListing();
			}else{
				//throw Error("不存在配置文件中的目录")
			}
			for(var i:int=0;i<items.length;i++){
				var f:File=items[i]
				if(f.isDirectory){
					ds.push(f)
				}
			}
			return ds;
		}
		public static function loadFiles(directory:File,oneOK:Function,allOK:Function):void
		{
			var items:Array=getFiles(directory)
			loadedFileNum=0;
			totalFileNum=items.length;
			for(var i:int=0;i<items.length;i++){
				var f:File=items[i]
				loadOneFile(f,oneOK,allOK,countOK)
			}
		}
		private static function loadOneFile(f:File,oneOK:Function,allOK:Function,count:Function):void
		{
			count(readFile(f),oneOK,allOK)
		}
		public static function loadFile(f:File,oneOK:Function):void
		{
			oneOK(readFile(f))
		}
		private static function readFile(f:File):String
		{
			var result:String=f.parent.name+File.lineEnding;
			var s:FileStream=new FileStream();
			s.open(f,FileMode.READ);
			result+=s.readMultiByte(s.bytesAvailable,"utf-8");//File.systemCharset
			s.close();
			return result
		}
		private static function countOK(result:String,oneOK:Function,allOK:Function):void
		{
			loadedFileNum++
			oneOK(result)
			if(loadedFileNum==totalFileNum){
				allOK()
			}
		}
		public static function saveJPG(bmp:BitmapData,path:String):void
		{
			var f:File = File.desktopDirectory.resolvePath(path);
			if(f.exists)return;
			var encoder:JPGEncoder = new JPGEncoder(100);
			var bytes:ByteArray = encoder.encode(bmp);
			bytes.position = 0;
			var s:FileStream=new FileStream();
			s.open(f,FileMode.WRITE);
			s.writeBytes(bytes,0,bytes.bytesAvailable);
			s.close();
			
		}
		public static function saveBytes(bytes:ByteArray,path:String,rewrite:Boolean):void
		{
			var f:File = File.desktopDirectory.resolvePath(path);
			if(!f.exists||rewrite){
				bytes.position = 0;
				var s:FileStream=new FileStream();
				s.open(f,FileMode.WRITE);
				s.writeBytes(bytes,0,bytes.bytesAvailable);
				s.close();
			}else{
				trace('FileUtil: ignore save file',path);
			}
		}
		public static function savePNG(bmp:BitmapData,path:String,rewrite:Boolean):void
		{
			var f:File = File.desktopDirectory.resolvePath(path);
			if(!f.exists||rewrite){
//			var encoder:PNGEncoder = new PNGEncoder();
			var bytes:ByteArray = PNGEncoder.encode(bmp);
			bytes.position = 0;
			var s:FileStream=new FileStream();
			s.open(f,FileMode.WRITE);
			s.writeBytes(bytes,0,bytes.bytesAvailable);
			s.close();
			}
		}
		public static function checkExsit(path:String):Boolean
		{
			var f:File = File.desktopDirectory.resolvePath(path);trace("，");
			return f.exists;	
		}
	}
}