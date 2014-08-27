package com.wehaverhythm.air
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	
	public class AppStorage
	{
		public function AppStorage()
		{
			
		}
		
		public static function save(obj:*, filePath:String):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath( filePath );		
			var fs:FileStream = new FileStream();
			
			fs.open( file, FileMode.WRITE );
			fs.writeObject( obj );
			fs.close();
		}
		
		public static function load(filePath:String):*
		{
			var file:File = File.applicationStorageDirectory.resolvePath( filePath );	
			
			if (file.exists)
			{
				var fs:FileStream = new FileStream();
			
				fs.open( file, FileMode.READ );
				var obj:* = fs.readObject();
				fs.close();
			
				return obj;
			}
			else return null;
		}
	}
}