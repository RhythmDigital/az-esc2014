package
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class TextFileWriter extends EventDispatcher
	{
		private var filePath:String;
		private var fileName:String = "AZ_ESC_Emails.txt";

		private var f:File;
		
		public function TextFileWriter(target:IEventDispatcher=null)
		{
			super(target);
			
			filePath = File.desktopDirectory.url;
			f = new File(filePath +"/"+ fileName);
			
			if(!f.exists) {
				var fs:FileStream = new FileStream();
				fs.open(f, FileMode.WRITE);
				fs.writeUTFBytes("");
				fs.close();
			}
		}
		
		public function writeLine(line:String):void
		{
			trace("Writing line " + line + " to " + f.url);
			var fs:FileStream = new FileStream();
			fs.open(f, FileMode.APPEND);
			fs.writeUTFBytes(line+"\r");
			fs.close();
		}
	}
}